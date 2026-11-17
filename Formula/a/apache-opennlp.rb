class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-3.0.0/apache-opennlp-3.0.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-3.0.0/apache-opennlp-3.0.0-bin.tar.gz"
  sha256 "bfd1ea2f4aeec30feba81608ab33437693da45be7d261fb35c20e06a9e0b2efc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ba7f5d2480a4243cbb6b6ef8264409190692249aa0837739bf799143af2b352"
  end

  depends_on "openjdk"

  deny_network_access!

  def install
    # Remove Windows scripts
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    (bin/"opennlp").write_env_script libexec/"bin/opennlp", JAVA_HOME:    formula_opt_prefix("openjdk"),
                                                            OPENNLP_HOME: libexec
  end

  test do
    output = pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends", 0)
    assert_equal "Hello , friends", output.lines.first.chomp
  end
end
