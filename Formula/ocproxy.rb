class Ocproxy < Formula
  desc "User-level SOCKS and port forwarding proxy"
  homepage "https://github.com/cernekee/ocproxy"
  url "https://github.com/cernekee/ocproxy/archive/v1.60.tar.gz"
  sha256 "a7367647f07df33869e2f79da66b6f104f6495ae806b12a8b8d9ca82fb7899ac"
  head "https://github.com/cernekee/ocproxy.git"

  bottle do
    cellar :any
    sha256 "f4af1432c292f21479bb598a61fc9d37bd9b0a592e3b2fd09584535918391533" => :mojave
    sha256 "5671c31a3b0392b5c4c9ea21644c4cbeb430e78dc9f24c28622e9a47ec7e3324" => :high_sierra
    sha256 "cb12a1bc3320c0ca5580a44256f5a627f1d74ad59a315cc3cf7aa87846a30243" => :sierra
    sha256 "d3f9801c5f0ffa066bdd6e00006488a6e69144beb9385f1bd70467684f50130c" => :el_capitan
    sha256 "15393addc83cc3da3a88fa62e80e2e149a85c627fdd1a4320be6f47b5b74f10f" => :yosemite
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
