class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.2/dar-2.7.2.tar.gz"
  sha256 "973fa977c19b32b1f9ecb62153c810ba8696f644eca048f214c77ad0e8eca255"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, monterey:     "0f206421be73b76aeecc377d04d45e179fd8c37c89b725311f7bc5278b693993"
    sha256 cellar: :any, big_sur:      "1fdd6b3a1928e14d8f912e37ae55e0e3c86186a5da2bc99c107f2c7b8b977c83"
    sha256 cellar: :any, catalina:     "da74fe3bf555027687c08c1070ded75381c823063d61e041573cf1b97899ce62"
    sha256 cellar: :any, mojave:       "a68d869a6b947f9a0d72afb03f11d1fae3a3401e7a4cd12737b272dae8988cb3"
    sha256               x86_64_linux: "cd8313b7fca09d8045b7f6b318b4668f3a986a8ebfc6d5f801883d079de503a3"
  end

  depends_on "upx" => :build
  depends_on "libgcrypt"
  depends_on "lzo"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-build-html",
                          "--disable-dar-static",
                          "--disable-dependency-tracking",
                          "--disable-libxz-linking",
                          "--enable-mode=64"
    system "make", "install"
  end

  test do
    system bin/"dar", "-c", "test", "-R", "./Library"
    system bin/"dar", "-d", "test", "-R", "./Library"
  end
end
