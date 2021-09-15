class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-1.9.3/apache-opennlp-1.9.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-1.9.3/apache-opennlp-1.9.3-bin.tar.gz"
  sha256 "935eb148e3b5c5d60f80fe27d9b9de5640d385bbe2c59b046ab669375ccc4350"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f98e8cd9fb35f0223fded988a07b95e4327087c49c776c995a66345646f1fc26"
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
