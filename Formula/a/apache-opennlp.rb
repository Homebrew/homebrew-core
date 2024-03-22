class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.3.2/apache-opennlp-2.3.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.3.2/apache-opennlp-2.3.2-bin.tar.gz"
  sha256 "8d053305c3f1321392323cd5bd17c2c5e2bb5c6daba218be06d545c614e58b84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fda828f064f5220cc184d5b441d8cda71f2b30423c52cffad6a193fc8de87825"
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
