class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  stable do
    url "https://mupdf.com/downloads/archive/mupdf-1.26.9-source.tar.gz"
    sha256 "54ceeaab4a694526d9db7282431e62d3ff9b1ca52da0c5dbf0c82c9a43361a1d"

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
    sha256 cellar: :any,                 arm64_tahoe:   "5e22efcc30dac1795e5a62b53577340cfd4c21df3e6f635cb18fe972da94ae7a"
    sha256 cellar: :any,                 arm64_sequoia: "9cbce2be30681bfe16468767035aed695169a041501dce494ba86707e3a10cb2"
    sha256 cellar: :any,                 arm64_sonoma:  "ca1ee3eed6b3d9ccf9635d88219376600406e4309bea17e433a74070d7656bb0"
    sha256 cellar: :any,                 sonoma:        "32bbf12aace11b93ec85c74b7cdc52202f47a338a8fe44a7583b0348a4bdb79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4708d62c6307bf8e6fb9c664e76df696b00c19b04751124104a0cc64250a41e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac723f2f6646d7ab6ec8db2f3615ea057f207f99c26e1bf7bcad020b0812b811"
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
  depends_on "python@3.13"
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
    site_packages = Language::Python.site_packages("python3.13")
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
