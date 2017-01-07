class Ats2Postiats < Formula
  desc "Statically typed programming language that unifies implementation and formal specification"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.2.13/ATS2-Postiats-0.2.13.tgz"
  sha256 "316eb28470154fb96ed69fddd5ef3477c4986835c48ab3e932fdaec7e7f23307"

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
