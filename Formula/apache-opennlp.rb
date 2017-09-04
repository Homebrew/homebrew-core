class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.8.1/apache-opennlp-1.8.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-1.8.1/apache-opennlp-1.8.1-bin.tar.gz"
  sha256 "86098147a75bf590e93ccbcb95d2b9f83c1ca198350b93dc989898700cc63c18"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/opennlp"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
