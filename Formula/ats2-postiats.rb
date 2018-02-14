class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.9/ATS2-Postiats-0.3.9.tgz"
  sha256 "c69a7c58964df26227e77656659129ca4c05205d2ebcacc7084edba818fb6e81"

  bottle do
    cellar :any
    sha256 "45a0f5428914af012b5292a062bf7af032d9955c49b66e4d12b638505b2ad03d" => :high_sierra
    sha256 "305068e69e2519a2d1ecb212e7b3f32d22fc98932088c6d959fddb3c76cb2c73" => :sierra
    sha256 "1a2f22aa7d162b238a171dcebe7d87675601ec8028638f3f5aec55eaba8838fc" => :el_capitan
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<~EOS
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
