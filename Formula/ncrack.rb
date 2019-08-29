class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://github.com/nmap/ncrack/archive/0.7.tar.gz"
  sha256 "f3f971cd677c4a0c0668cb369002c581d305050b3b0411e18dd3cb9cc270d14a"
  head "https://github.com/nmap/ncrack.git"

  bottle do
    sha256 "899782e40fc6cce6aaa19f37719a914d5a255e50bce22f1d834f383e2b5288fc" => :mojave
    sha256 "710a7c1bbc131cce0e0b5ceac7bee02c829362489a56a881b2011df7bcab7dfb" => :high_sierra
    sha256 "887e071b2c1468c82c1d4ab390f0bbb6c03a482f0c39e89a573105d2ce5cb38c" => :sierra
    sha256 "1ca0625ada66ae28f5bc488ecc7ca246d68711ab6b314c4f6998ab47ccba1ec0" => :el_capitan
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output(bin/"ncrack --version")
  end
end
