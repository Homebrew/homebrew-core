class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.4.1/ATS2-Postiats-0.4.1.tgz"
  sha256 "03f4bf7205f76732624c32a4bf0b346ddace23fdb5a1cde25c378d33043aaa3c"
  license "GPL-3.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/ATS2-Postiats[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "31e2f0c1a4e5e24ff4dfe3249f3713ef233c9440e4f14919faec3d330f8442c6" => :catalina
    sha256 "8c92d41d016bfdbbe3e8a85cd2732eed7ad829ce3195b1179022fc21fffd7788" => :mojave
    sha256 "c468d51fd400472c4c311dd3649bff46c4d43c38c29b17b47e08ec1b0d73e869" => :high_sierra
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
