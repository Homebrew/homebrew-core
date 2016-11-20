class Ats2Postiats < Formula
  desc "ATS programming language implementation"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.11/ATS2-Postiats-0.2.11.tgz"
  sha256 "0fe99975fe5eb86b884c4bcfd3c5b6d0015793f2d8c8455c5b21649744f01d90"

  bottle do
    cellar :any
    sha256 "dd2987c2c5a30b7fdb0863597e69bcb58c17cda9385675e15d95d740849eea33" => :sierra
    sha256 "11b07486d678c6a7c6f0363ccb3b00a04b244783eea91cbe7f32104d8c633694" => :el_capitan
    sha256 "2b6c12b3bed10dd3a04ab72a35e21ada97281b222a2b401511cf83c9afb797b8" => :yosemite
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
