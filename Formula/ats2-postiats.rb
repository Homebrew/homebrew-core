class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.3/ATS2-Postiats-0.3.3.tgz"
  sha256 "e8fe0fb96bae2c988d44f8f1a564faa4d3ef9f1dafc4f406f584f94700013972"

  bottle do
    cellar :any
    sha256 "741f25b8b8f356ff79a3d9d0f1d9c1e61c0fcbee1ff682661e58ada73df477bd" => :sierra
    sha256 "9264a6eaa04a382dea9c4d565c133f221c36ff54695d55efd52d4bb9d208ed78" => :el_capitan
    sha256 "1bf5329d5ad10540300b9f1952e3c6ed47ca92fe13d13f1c8cb34b0c051690ea" => :yosemite
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<-EOS.undent
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
