class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "https://github.com/gosu-lang/gosu-lang/archive/v1.14.5.tar.gz"
  sha256 "d0381423c5b43934b905d99441ffa5909393c9f5bce011d5bb6cb613c63cc80d"
  head "https://github.com/gosu-lang/gosu-lang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2df92a79efcc5e18b46a2077dcb8a578a405ba05076268c317630ae504cafe7" => :sierra
    sha256 "63c84c0c30c3268e5ae36a0ab7255be4bbb1a7a7a9e7e3dead124f26aa4c3bb4" => :el_capitan
    sha256 "802084858ae9dc62ac0d0d3fa701dc1968c44d887fcb2672ca96cb930439f82c" => :yosemite
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
