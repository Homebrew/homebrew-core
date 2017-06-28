class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.0.0.tar.gz"
  sha256 "18a13c954f7297978e7bf1a0cdadde7c531e519d61a045dae304e054f3b2df03"

  bottle do
    cellar :any
    sha256 "a6f031a29e43ee5af71d20f9c9b86bc138ad55a1c41faef1f2f852b5595912a8" => :sierra
    sha256 "b0a4712e735be9c798ba7f9233db9339a09dc70b69c88c318fc14662972f5511" => :el_capitan
    sha256 "01816d798919670ccce2726b59aa1752d4f6ef2a3e74df5e9141882c778e1f37" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
