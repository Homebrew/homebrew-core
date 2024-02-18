class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.23.10-source.tar.gz"
  sha256 "c3a2eaf19b3f0d58f923bf7132b72eff6205db4cea2f9c4651ee5ec9095242da"
  license "AGPL-3.0-or-later"
  head "https://git.ghostscript.com/mupdf.git", branch: "master"

  livecheck do
    url "https://mupdf.com/downloads/archive/"
    regex(/href=.*?mupdf[._-]v?(\d+(?:\.\d+)+)-source\.(?:t|zip)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cde99551ee8b9c127da16efa7eedbe015ac5ad3ccc3d0206634413e1c68c0306"
    sha256 cellar: :any,                 arm64_ventura:  "7b475e0f4d4584b38e1411533a47952f1fde0dba2420cff2c43817e0dbdec724"
    sha256 cellar: :any,                 arm64_monterey: "bd5b2d4cd284e0fa49f3a0e7d94e2432b152ac794b63cc567baf5d434ba2c899"
    sha256 cellar: :any,                 sonoma:         "d6d70f68b68b89be4c401cee376481451dceba782a594fa1867ee0d4e2927b46"
    sha256 cellar: :any,                 ventura:        "17a4184dc8a169b4b4a84d522b94f3d2607c06896dd32b8804f78520fc6c4eae"
    sha256 cellar: :any,                 monterey:       "0647ddbdeb8cd995939272e63cc6068734f67d3d69815d8a1c3b788c6f1eaa1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3686647db04b81c97b92e8af730d147c58760e103ee40a28764ae541e9045c77"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gumbo-parser"
  depends_on "harfbuzz"
  depends_on "jbig2dec"
  depends_on "jpeg-turbo"
  depends_on "mujs"
  depends_on "openjpeg"
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "mesa"
  end

  conflicts_with "mupdf-tools",
    because: "mupdf and mupdf-tools install the same binaries"

  def install
    # Remove bundled libraries excluding `extract` and "strongly preferred" `lcms2mt` (lcms2 fork)
    keep = %w[extract lcms2]
    (buildpath/"thirdparty").each_child { |path| path.rmtree if keep.exclude? path.basename.to_s }

    args = %W[
      build=release
      shared=yes
      verbose=yes
      prefix=#{prefix}
      CC=#{ENV.cc}
      USE_SYSTEM_LIBS=yes
      USE_SYSTEM_MUJS=yes
    ]
    # Build only runs pkg-config for libcrypto on macOS, so help find other libs
    if OS.mac?
      [
        ["FREETYPE", "freetype2"],
        ["GUMBO", "gumbo"],
        ["HARFBUZZ", "harfbuzz"],
        ["LIBJPEG", "libjpeg"],
        ["OPENJPEG", "libopenjp2"],
      ].each do |argname, libname|
        args << "SYS_#{argname}_CFLAGS=#{Utils.safe_popen_read("pkg-config", "--cflags", libname).strip}"
        args << "SYS_#{argname}_LIBS=#{Utils.safe_popen_read("pkg-config", "--libs", libname).strip}"
      end
    end
    system "make", "install", *args

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"

    lib.install_symlink lib/shared_library("libmupdf") => shared_library("libmupdf-third")
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
