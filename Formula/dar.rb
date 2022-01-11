class Dar < Formula
  desc "Backup directory tree and files"
  homepage "http://dar.linux.free.fr/doc/index.html"
  url "https://downloads.sourceforge.net/project/dar/dar/2.7.3/dar-2.7.3.tar.gz"
  sha256 "c3bd34e517592a33fb5eb3bf878df23342ec868e0c38a58bca7262983da81f06"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/dar[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, monterey:     "daf54c249f1aeb0de1d5d899a7891a0714c907173e8202fca3dca03f95215066"
    sha256 cellar: :any, big_sur:      "556e064ef047a4c84af0200c1a18be7c8ee165b2825e623634282ed35e287cd9"
    sha256 cellar: :any, catalina:     "d29fc17511b26f554f26e7feffea3f9b69aec38b8080048e8e5c8f02ef7ec4c3"
    sha256               x86_64_linux: "ed4ae171a9d7c66ba49690d06e2f42752130815c6f966dac256ef481d7b63770"
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
