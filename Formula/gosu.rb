class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.5.tar.gz"
  sha256 "d0381423c5b43934b905d99441ffa5909393c9f5bce011d5bb6cb613c63cc80d"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d44c6af931c04e52a90f81e5fd0d2d0c4446ef8212288a1c98a8781d50674c9" => :sierra
    sha256 "9de81411f28aac5e95decf2d551817644c3cc0aa5573ce932e40023e261066a9" => :el_capitan
    sha256 "0dbc4e42ab9abd76b5f7552896ae8af303e2a863a2d43928d3b347c7e8a4acac" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on "maven" => :build

  skip_clean "libexec/ext"

  def install
    ENV.java_cache

    system "mvn", "package"
    libexec.install Dir["gosu/target/gosu-#{version}-full/gosu-#{version}/*"]
    (libexec/"ext").mkpath
    bin.install_symlink libexec/"bin/gosu"
  end

  test do
    (testpath/"test.gsp").write 'print ("burp")'
    assert_equal "burp", shell_output("#{bin}/gosu test.gsp").chomp
  end
end
