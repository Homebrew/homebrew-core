class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.27.0-source.tar.gz"
  sha256 "ae2442416de499182d37a526c6fa2bacc7a3bed5a888d113ca04844484dfe7c6"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f220b26700cafb1949b7338bd3d9ab9cf6d7bad31f92e647fc16457d0c37aa95"
    sha256 cellar: :any,                 arm64_sequoia: "f052033b4c55fe7c89e5276f82d32bf890494fba7d298053ea6ae594b960f907"
    sha256 cellar: :any,                 arm64_sonoma:  "a47e4f44c449edefe399c8cf7a28a45ac3cc3379e0eade6da06622d03a9e0ade"
    sha256 cellar: :any,                 sonoma:        "e0edc930d9b49c8c0ae9af842fc8fcd249e34544c328fbeaf50c430fac876ccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e02b5117b38d4fc87d73ad6a32cb54979893bb7fcfad41dbdce06cbae7e1e19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0272a405452dfb464b7529a2140b2c851f14c07ef80d6da5075afbd0431fd614"
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

  uses_from_macos "zlib"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
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
