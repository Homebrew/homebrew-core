class GnuShogi < Formula
  desc "GNU Shogi (Japanese Chess)"
  homepage "https://www.gnu.org/software/gnushogi/"
  url "https://ftp.gnu.org/gnu/gnushogi/gnushogi-1.4.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnushogi/gnushogi-1.4.2.tar.gz"
  sha256 "1ecc48a866303c63652552b325d685e7ef5e9893244080291a61d96505d52b29"

  bottle do
    sha256 "677531c9eb7bdd01f22862c24d5ab144f7b78bd672223854fc169d103a9924e2" => :sierra
    sha256 "49ff431036e172362b24dc7eca426a638ec2953ea014c67e4cae239e9175bf27" => :el_capitan
    sha256 "1fbc9bf567ea4c50c5bb12fda953e18ce8617298d474ed8a56ca2b9dd24b2726" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install", "MANDIR=#{man6}", "INFODIR=#{info}"
  end

  test do
    (testpath/"test").write <<-EOS.undent
      7g7f
      exit
    EOS
    system "#{bin}/gnushogi < test"
  end
end
