class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.3/ATS2-Postiats-0.3.3.tgz"
  sha256 "e8fe0fb96bae2c988d44f8f1a564faa4d3ef9f1dafc4f406f584f94700013972"

  bottle do
    cellar :any
    sha256 "b64895d38ddc05d29d68c217959a538c21831f31a5152cae5d91a72fe3e4c911" => :sierra
    sha256 "2946e2250329356ffe431b86e8a5abb1cf436ee89de4f1f7a0245856552506ce" => :el_capitan
    sha256 "16612b33029349b57cca91e71ad4cbaf4754dc237fe99768a9c1239bb747f5d7" => :yosemite
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
