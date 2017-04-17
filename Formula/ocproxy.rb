class Ocproxy < Formula
  desc "User-level SOCKS and port forwarding proxy"
  homepage "https://github.com/cernekee/ocproxy"
  url "https://github.com/cernekee/ocproxy/archive/v1.60.tar.gz"
  sha256 "a7367647f07df33869e2f79da66b6f104f6495ae806b12a8b8d9ca82fb7899ac"
  head "https://github.com/cernekee/ocproxy.git"

  bottle do
    cellar :any
    sha256 "9af4d8b9a9aac6223eb56d288e75e22f15826c768a1508863a16b93929515dbd" => :sierra
    sha256 "e3ccb32bf2b4d051f9d4b20bb51c2d9387f45265e8450bc0b2addb8e7cdfae12" => :el_capitan
    sha256 "9ff8e3e1e1395650b022ac98295f97b5c31c48319279f491157aeaf8766190ea" => :yosemite
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
