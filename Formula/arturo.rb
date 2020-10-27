class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "http://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.4.6.tar.gz"
  sha256 "90dfd8870ab0bfadd14cd611a33353a1d4b66b25e0c56d75cab895989be25c98"
  license "MIT"

  bottle do
    cellar :any
    sha256 "b4a5f610f82c3a10ddb4a03936690c9bec560d16218e5b952e8690d7853adbfd" => :catalina
    sha256 "1cbeced6fff8823b2405bb7d75360236f5686e8edcddb1113e5f98146b2138dc" => :mojave
    sha256 "56f91a92ff90cf0282128601c23d486fac24ce218d5ce0a034d20b652c4f2932" => :high_sierra
  end

  depends_on "nim" => :build
  depends_on "gmp"

  def install
    system "./build.sh"
    bin.install "bin/arturo"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
