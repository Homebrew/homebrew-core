class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.3.3/apache-opennlp-2.3.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.3.3/apache-opennlp-2.3.3-bin.tar.gz"
  sha256 "63dacde27ee052aa6866d01fbe88adce8c13c0c207975d98569bdbc80b33697d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a53cded7fd7d79ba964e4ec272e05cdb39f16d23af7a8b2eda0d74ec71ce3a5c"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
    # script uses a relative path to the conf folder
    inreplace libexec/"bin/opennlp", "../conf", "$OPENNLP_HOME/conf"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
