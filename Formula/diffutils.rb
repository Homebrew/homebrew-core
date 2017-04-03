class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftpmirror.gnu.org/diffutils/diffutils-3.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/diffutils/diffutils-3.5.tar.xz"
  sha256 "dad398ccd5b9faca6b0ab219a036453f62a602a56203ac659b43e889bec35533"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d8968585e5e79fd760316cc64df9bc10cdcd83d956317ff48d0cd84a38a6f77a" => :sierra
    sha256 "1e353b1bee28e5e1c3078969ed95c5f81ded631f9d92d89a7c75228dfe56fb27" => :el_capitan
    sha256 "580a0d3229f731cce84112196d0402e2e4ee2a101f682a12a4ac0ed7500714fb" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
