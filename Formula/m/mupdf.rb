class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.28.3-source.tar.gz"
  sha256 "37c3209dc0e06fa4f3781ed44839ad933a9e6143eb4731f99e069204715bcef2"
  license "AGPL-3.0-or-later"
  compatibility_version 6
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1e20963ff995c1a710026ad04a98fe9125c5690a0a773f21bb23ecc24d4a5a90"
    sha256 cellar: :any, arm64_sequoia: "9635c8e6292b6b8db2c62514478b056f270f514e0562fe733d01821dba65f33e"
    sha256 cellar: :any, arm64_sonoma:  "3cc432932538d075571e6472ed00e29d9502deb0ea81fb9623bebe3964adcd4a"
    sha256 cellar: :any, sonoma:        "8948445a765fb18c4f01d35a26a921d07a6483cb36e98da21fe458604928c6b2"
    sha256 cellar: :any, arm64_linux:   "d7f91440ef45a5a5439203aeece5d067643dd755a6b82e15e0fb67d002a5c8e5"
    sha256 cellar: :any, x86_64_linux:  "777691907a61320173032293c2e974d7c6943ff6a87836c8048304ec068cddbc"
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
    url "https://mujs.com/downloads/mujs-1.3.9.tar.gz"
    sha256 "956d5a20dd4efe5aa58673558787b9e2539255f9bf62585e90e1921fa040d89d"

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
    url "https://files.pythonhosted.org/packages/64/1a/9ab2b272def9db9c80bf18fe8282119c2c4c074cc542030a28e4136dd13b/pipcl-12.tar.gz"
    sha256 "c7545480cfa808500d8b606da73db7f89a872258bcdb293716126e2ccff1a5c6"
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
