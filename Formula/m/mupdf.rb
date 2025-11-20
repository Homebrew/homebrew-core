class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  license "AGPL-3.0-or-later"
  head "git://git.ghostscript.com/mupdf.git", branch: "master"

  stable do
    url "https://mupdf.com/downloads/archive/mupdf-1.26.11-source.tar.gz"
    sha256 "eee47fdb64de309124df21081d4a4da4ad0e917824ab2ed68fc8008f6b523979"

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
    sha256 cellar: :any,                 arm64_tahoe:   "cd5818bd421ebfd86bfa111d5178293da1928c36308acef9531936b66252d1f6"
    sha256 cellar: :any,                 arm64_sequoia: "c7fd273f963ddab4ee314a2e5b2b817ebccab485afdfef919820d5a1a2a12e38"
    sha256 cellar: :any,                 arm64_sonoma:  "ccc19870d0ab3108f2c856e4829c015fceb36d10509dbcf0f701a6a685409577"
    sha256 cellar: :any,                 sonoma:        "644b8b7ef7246d445aab052059958058c7dfe6793538f5701f4b5ae6dd99cce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f63c7626e9ab1b4511dc297e3ea0649f33ed5c2c0a23f28a35a5510b004ec55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08d5b6fcef7471800eeb4820cd5c66ad5506446f0b0fe7acf57f6b97c659c51c"
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
