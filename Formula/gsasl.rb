class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-1.8.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-1.8.1.tar.gz"
  sha256 "4dda162a511976bfef14ad1fecd7733719dfd9c361b5d09dc8414ea9d472d8d2"

  bottle do
    cellar :any
    rebuild 3
    sha256 "d60d223245fcca817c96ac40755fc41a17289ded2c9cf06d8cbc38457b5739ef" => :catalina
    sha256 "d52080e846621b8b297fb8f100c077a859545b933ec527573a02addddca0b40d" => :mojave
    sha256 "9e6544e25c68eff0e352ba84355a9a6ea201b9b533cbb9420eee3bdfd1531eb3" => :high_sierra
    sha256 "22c6d1dd63deb2e26dd8e3b2b51b30735ada08b6972222eed3d1868fddf1ed3c" => :sierra
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gsasl")
  end
end
