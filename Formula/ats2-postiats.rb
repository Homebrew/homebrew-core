class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.4.0/ATS2-Postiats-0.4.0.tgz"
  sha256 "a749b62d429eda45ec304075f1743e1a2638c4772d37b579839d7797470869c0"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4b7bf748d9ad11c38273dd2fc11d273c8f02a1702778ef368307c57f1b4f402" => :catalina
    sha256 "d86462909117de7a2a09d0816df8909c5d0b6cba14f24932612f4c3c54734453" => :mojave
    sha256 "c787afdba7391ce0aa745938259f3dc79e8b97d0842daa378de854def8c4a9bd" => :high_sierra
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
