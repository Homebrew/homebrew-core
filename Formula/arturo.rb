class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "http://arturo-lang.io"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.4.6.tar.gz"
  sha256 "90dfd8870ab0bfadd14cd611a33353a1d4b66b25e0c56d75cab895989be25c98"
  license "MIT"

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
