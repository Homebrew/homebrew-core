class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.4.0/apache-opennlp-2.4.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.4.0/apache-opennlp-2.4.0-bin.tar.gz"
  sha256 "dd0cee5542e128130333e99bbea649f5fd5eb6f264fd4e1c6403f0427077c2ef"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "42cf0a7445e9c93111baffa1bed63d57fddd3c73dce8fbdb33d9a741cefa2061"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
