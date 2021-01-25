class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.4.2/ATS2-Postiats-0.4.2.tgz"
  sha256 "a6facf2ba3e8bb0b3ca9b62fd0d679c31a152842414fccd34079101739042c59"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ATS2-Postiats[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2e7267a095f51b3cdc898bb3dd5c051613383a7b79019b291c1586b3d8fe2ec0" => :big_sur
    sha256 "938b458e7e8701d45fdc90ce46157b9e75017efee8cb20b089d5964419bb4922" => :arm64_big_sur
    sha256 "19ea3eb93cc5ba40ce3c1bdc48666edd4a8cd00027fbb4531392a0f15ecc7a94" => :catalina
    sha256 "9e0b2824b0ea3d67e22c6690d3608c5d09d9855075e9811ad71b5f2703be9304" => :mojave
    sha256 "91d683a9f1c94daff0e9b089cc7a5ceda949eb4b5aa7d286c554d9506ee6d49c" => :high_sierra
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
