class Netmask < Formula
  desc "IP address formatting tool"
  homepage "https://github.com/tlby/netmask"
  url "https://github.com/tlby/netmask/archive/v2.4.4.tar.gz"
  sha256 "7e4801029a1db868cfb98661bcfdf2152e49d436d41f8748f124d1f4a3409d83"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "10.0.0.0/23", shell_output("#{bin}/netmask 10.0.0.0:10.0.1.255").strip
  end
end
