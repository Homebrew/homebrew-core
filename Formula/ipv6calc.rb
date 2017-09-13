class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/1.0.0.tar.gz"
  sha256 "74b0455e61834843bf8a5e7e0e0f39dd2b148114ff896d590eb2d826714594bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6bdf091f2496a5ffcb776d18fd1dba83ca1051c9755c45449183e7c22d8814a" => :sierra
    sha256 "768f3b011dd2c900b2d3030d63eba0d4ae3c417ba6aa5a9f4802a686ef74c562" => :el_capitan
    sha256 "a129eaac7552df52afc8be73d6644ea4b556847efc9be48baf208fe04ca164e0" => :yosemite
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97", shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
