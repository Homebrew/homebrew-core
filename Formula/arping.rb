class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.19.tar.gz"
  sha256 "b1477892e19687a99fa4fb42e147d7478d96d0d3fc78ca4faade6392452414db"

  bottle do
    cellar :any
    sha256 "6e48f1e3310062c41d259b2167a6962b998cf3e3cb027a4b4ad089e326bb280b" => :sierra
    sha256 "d4419b74f19edeed76c52e9d00f527615701434ab675a84cd23eb1224d5f109c" => :el_capitan
    sha256 "7e36e19003b66683f41f2774c1a10c808edd9298d211c8eaa04efcc3e14a1c72" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
