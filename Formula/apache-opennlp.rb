class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.0.0/apache-opennlp-2.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.0.0/apache-opennlp-2.0.0-bin.tar.gz"
  sha256 "5a37903c286cd2bd6b769d965ec785f0a2e1a597323bb6123f15ea14d0097f6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47d390d8a18b2ba2ff91a9ed06cba6a85d591bce1c12afad4f6e9e452840cb8d"
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
