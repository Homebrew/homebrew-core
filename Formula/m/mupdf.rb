class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.27.2-source.tar.gz"
  sha256 "553867b135303dc4c25ab67c5f234d8e900a0e36e66e8484d99adc05fe1e8737"
  license "AGPL-3.0-or-later"
  compatibility_version 2
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "adfc5220c9f64113fc61920f81073107d3baf4c1139c884f6f7d78f0de3a437b"
    sha256 cellar: :any,                 arm64_sequoia: "c8e638337695132e732310023481986c1ec2d3d72d3d5640751e31f780306c36"
    sha256 cellar: :any,                 arm64_sonoma:  "69f930f318dd7ad6c5b12d419ed65e90ed26c6a33ca47ef7e2cc040d0f6c045c"
    sha256 cellar: :any,                 sonoma:        "0120967cfd6b2f95be99963d5453aac7fc3f6942c48633189369fb816b0e344f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9c407b06730358c2ad4a6c3ead32af302b649ac6858fc73c013353b669672b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22d86c746fddcc6e410442ce198defcd205663c6a1b660c5308dda0ee2124cb3"
  end

  depends_on "llvm" => :build
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
    url "https://mujs.com/downloads/mujs-1.3.8.tar.gz"
    sha256 "506d34882f2620a2fdeb6db63dbb7a8ffd98f417689d8f3c84f2feac275e39a9"

    livecheck do
      "mujs"
    end
  end

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| rm_r(path) if keep.exclude? path.basename.to_s }

    # Install mujs from resource
    (buildpath/"thirdparty/mujs").install resource("mujs")

    # For python bindings needed by `pymupdf`: https://pymupdf.readthedocs.io/en/latest/packaging.html
    site_packages = Language::Python.site_packages("python3.14")
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/site_packages

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
