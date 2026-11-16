class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-2.5.13/apache-opennlp-2.5.13-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-2.5.13/apache-opennlp-2.5.13-bin.tar.gz"
  sha256 "0341e4b0f2acc81de8813fcc3d8a1aed3110429119a3753a4a065bd377b552b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95c9636ef1de84cca0ee9901ef120289ef2996922ade379de9a4c8b40af31844"
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
