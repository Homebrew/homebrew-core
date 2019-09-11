class Ocproxy < Formula
  desc "User-level SOCKS and port forwarding proxy"
  homepage "https://github.com/cernekee/ocproxy"
  url "https://github.com/cernekee/ocproxy/archive/v1.60.tar.gz"
  sha256 "a7367647f07df33869e2f79da66b6f104f6495ae806b12a8b8d9ca82fb7899ac"
  revision 1
  head "https://github.com/cernekee/ocproxy.git"

  bottle do
    cellar :any
    sha256 "786f0c42a3d282b78d8dc2fa18c36e46707451f4ac848e9af7dd82ab31b40f6d" => :mojave
    sha256 "0cd70ac67ebd419b869ad4dd70c6cd1217248c8e7b7a57d3a7c8e15c7d2f7dfc" => :high_sierra
    sha256 "8e33eae007c082ec9b6787210096a4e20992151a7b2c5f345941f68c478ae0e2" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libevent"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /VPNFD.is.not.set/, shell_output("#{bin}/ocproxy 2>&1", 1)
  end
end
