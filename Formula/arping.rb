class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.21.tar.gz"
  sha256 "7bf550571aa1d4a2b00878bb2f6fb857a09d30bf65411c90d62afcd86755bd81"

  bottle do
    cellar :any
    sha256 "ef1888a0b7fef648f4f2bb72e62b5c9760f99e200353ab1f73a57b955012ed50" => :catalina
    sha256 "857799b8c49838abb0fbe7d54b7c87de397233535fb1bfc04a88800e10a0f629" => :mojave
    sha256 "673a70e73e435f275d8d47c6034cebdffe57908d417abd617fa3c8973b393ce9" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

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
