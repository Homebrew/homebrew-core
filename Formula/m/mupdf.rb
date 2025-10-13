class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  license "AGPL-3.0-or-later"
  revision 1
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  stable do
    url "https://mupdf.com/downloads/archive/mupdf-1.26.10-source.tar.gz"
    sha256 "1653f35bd8fbd970f05523efdc7f86e41e9728e2564a3295296e03cf59a51437"

    # libclang-20 patches
    patch do
      url "https://github.com/ArtifexSoftware/mupdf/commit/df0b5ee3bb9b12d8c57df55d7b41faf1b874a14d.patch?full_index=1"
      sha256 "6968a8b80221b01cc30d46bf832ecbcba99d75de238c41315be318f2b02ac892"
    end
    patch do
      url "https://github.com/ArtifexSoftware/mupdf/commit/559e45ac8c134712cd8eaee01536ea3841e3a449.patch?full_index=1"
      sha256 "868c2955cbebcb99b5336c005cbe4a5867f8654cb9b008bd24ae67df84438968"
    end
    patch do
      url "https://github.com/ArtifexSoftware/mupdf/commit/4bbf411898341d3ba30f521a6c137a788793cd45.patch?full_index=1"
      sha256 "ac2b1c1b6c21626aaf009928262f7c31e407a886b192d276674ddb94672b1d38"
    end
  end

  livecheck do
    url "https://mupdf.com/releases"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8b5c3bef2f41a8221caabfb8345b6ab87f2795f375bafa1b837a9a597c413462"
    sha256 cellar: :any,                 arm64_sequoia: "5c75357e8cdf878d523c9554b96faf0cd4ce295a05c9796ab9303f66d19e6cb9"
    sha256 cellar: :any,                 arm64_sonoma:  "df0d6ef85af57972f10462a6c08ee883bcc0ad6acc31a8459042a09949ca268e"
    sha256 cellar: :any,                 sonoma:        "bfd42863a9640eea00c79534a6c73774a0be929bc851aaccc7cc6dc33eb26fdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea3327766c8b860dabfebee8cd315a8d8889e773bf1c923db12928ffd65c9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f031b0d617feb93c0b184baa0b997a41603d63700582cf4fa1f5089d294a5c4"
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
  depends_on "mujs"
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

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| rm_r(path) if keep.exclude? path.basename.to_s }

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
      USE_SYSTEM_MUJS=yes
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

      ENV.cxx11
    end

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
