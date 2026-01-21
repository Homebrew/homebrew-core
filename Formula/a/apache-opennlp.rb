class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  # Switched to official Maven until upstream adds files to Apache server
  # url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.6.1/apache-opennlp-2.5.6.1-bin.tar.gz"
  url "https://search.maven.org/remotecontent?filepath=org/apache/opennlp/opennlp-distr/2.5.7/opennlp-distr-2.5.7-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.7/apache-opennlp-2.5.7-bin.tar.gz"
  sha256 "8de91d4705d2d546986fe4ad4dc6e1d9ed7bfce0ef32340bb0f996eda6787a6f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "558d1162328b71825c618fec114e8952fbec5c88f4c87ba7a139fb29767ca290"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    Formula["openjdk"].opt_prefix,
                                                            OPENNLP_HOME: libexec
  end

  test do
    output = pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends", 0)
    assert_equal "Hello , friends", output.lines.first.chomp
  end
end
