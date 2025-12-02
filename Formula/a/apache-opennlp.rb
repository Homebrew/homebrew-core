class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  # Switched to official Maven until upstream adds files to Apache server
  # url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.6.1/apache-opennlp-2.5.6.1-bin.tar.gz"
  url "https://search.maven.org/remotecontent?filepath=org/apache/opennlp/opennlp-distr/2.5.6.1/opennlp-distr-2.5.6.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.6.1/apache-opennlp-2.5.6.1-bin.tar.gz"
  sha256 "da5ddb4c7aa2a89349dbd079c359974910c2e5f0a433d8dfde193ec85e3f2b5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e90c16ea4ad312c0919e2582673390161d12009e4574394659ec7d66232afcb5"
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
