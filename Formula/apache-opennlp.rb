class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-1.9.4/apache-opennlp-1.9.4-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-1.9.4/apache-opennlp-1.9.4-bin.tar.gz"
  sha256 "f6d61235d5212a6e9d7d9036ffe6379fa11fd9bf7374b9ebd156a0e676653289"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1df92f22c391505940d335ae17b43854e01406237b96b6ba5e634bf4a38d9f6c"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
