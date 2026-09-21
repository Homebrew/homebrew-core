class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.4-source.tar.gz"
  sha256 "2d97e043a616f96b148657c9c3d81ad71c4bd2052c59a2a3315ad842599340f9"
  license "AGPL-3.0-or-later"
  compatibility_version 7
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "22e23eb788bc864cc10a8dcebc98ba6f34cc366a8255c8f660f9e7024d65975d"
    sha256 cellar: :any, arm64_tahoe:       "33be235ebd5a0e3ff626ab3e9c0249f5ef45f71f2f097c97547ffe079b6c66f4"
    sha256 cellar: :any, arm64_sequoia:     "7f4da1c614664d7de90faf50d35a9b886b9754f054528999f34cc8278e8b5a86"
    sha256 cellar: :any, arm64_linux:       "63f8f292ae717885ed62312d7092fa5e45d3962a22ed1a57caeb1603fbdc27d8"
    sha256 cellar: :any, x86_64_linux:      "f0ba4418f56d40268965ada6fdcbd53abaa27b0b187c1031d93025e9965244ff"
  end

  depends_on "llvm@21" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "brotli"
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "leptonica"
  depends_on "openjpeg"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "tesseract"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mupdf-tools", because: "both install the same binaries"

  # Currently, some source of mujs is required for building mupdf, so can't use formula
  # Issue ref: https://bugs.ghostscript.com/show_bug.cgi?id=708968
  resource "mujs" do
    url "https://mujs.com/downloads/mujs-1.3.10.tar.gz"
    sha256 "6e36c15dbb84ff859320297c900852f241b131a7b6ddaea669ac9a65bd75571c"

    # Resource `livecheck` blocks don't support package references (yet), so we
    # can't use `formula "mujs"` here.
    livecheck do
      url "https://mujs.com/downloads/"
      regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  end

  # Build scripts import `pipcl`, which upstream unbundled in 1.28.1
  # Ref: https://github.com/ArtifexSoftware/mupdf/commit/ecef7b70bc5
  resource "pipcl" do
    url "https://files.pythonhosted.org/packages/1c/9d/d797318cf82fff625670bbbf88a722d87299c9d8f3fc8372603713ac0af4/pipcl-13.tar.gz"
    sha256 "286aba9785463c83659a565210a82a77896195d3303bff0542e825479b56daf2"
  end

  def install
    # Remove bundled libraries excluding `extract`, "strongly preferred" `lcms2mt` (lcms2 fork)
    # and `cmark-gfm` (mupdf builds against its private headers, so no system-lib option)
    keep = %w[cmark-gfm extract lcms2]
    (buildpath/"thirdparty").each_child { |path| rm_r(path) if keep.exclude? path.basename.to_s }

    # Install mujs from resource
    (buildpath/"thirdparty/mujs").install resource("mujs")

    # For python bindings needed by `pymupdf`: https://pymupdf.readthedocs.io/en/latest/packaging.html
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", formula_opt_prefix("llvm@21")/site_packages

    (buildpath/"pipcl").install resource("pipcl")
    ENV.prepend_path "PYTHONPATH", buildpath/"pipcl/src"

    args = %W[
      build=release
      shared=yes
      tesseract=yes
      verbose=yes
      prefix=#{prefix}
      pydir=#{prefix/site_packages}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=no
      VENV_FLAG=
    ]

    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LEPTONICA", "lept"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
        ["TESSERACT", "tesseract"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkgconf", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkgconf", "--libs", libname).strip}"
        args << "HAVE_SYS_#{argname}=yes"
      end

      # Workarounds since build scripts for Python bindings don't support macOS
      # Issue ref: https://bugs.ghostscript.com/show_bug.cgi?id=705376
      inreplace "Makefile" do |s|
        # Avoid creating a symlink that overwrites installed file
        s.gsub!(/^\s*ln -sf libmupdf/, "#\\0")

        # FIXME: libmupdfcpp should be a shared lib (.dylib) while _mupdf should be a bundle
        # (.so) as the former is a C++ library installed into `lib` while latter is loaded by
        # Python bindings. However, the python build scripts hardcode `.so` and uses `-shared`
        # which result in neither being correct. Also, the Makefile installs with $(SO) which
        # fails to find `.so`. For now we do the easier workaround of installing as `.so`.
        s.gsub! "libmupdfcpp.$(SO)", "libmupdfcpp.so"
        s.gsub! "_mupdf.$(SO)", "_mupdf.so"
      end

      ENV.append "CXX", "-std=c++14"
    end

    # Missing rpath for python bindings on macOS
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "make", "install", *args
    system "make", "install-shared-python", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
