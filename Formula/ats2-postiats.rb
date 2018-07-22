class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.10/ATS2-Postiats-0.3.10.tgz"
  sha256 "a65d0dccbfa3f462ad9348ea400de958166c011197cbef66ecf1c5c5f8baa276"

  bottle do
    cellar :any
    sha256 "08a99363f0ad55b413d58c1ce30530c7afda72d2b0072152867b74148546a9bb" => :high_sierra
    sha256 "f1fbfb0a08b5a3016ba8bf27b6b99d09235bed580d7ee2c33ec3ea28812b61d9" => :sierra
    sha256 "4134fcd2ff018c18309a78b13a94e7900b71d0dd3af0aab57ba9173c9cff3715" => :el_capitan
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
