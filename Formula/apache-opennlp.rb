class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.8.3/apache-opennlp-1.8.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-1.8.3/apache-opennlp-1.8.3-bin.tar.gz"
  sha256 "eb991f3bfe2847118676fe62d2c80a36b8deabb66b6de94b3de1b86cd9394bcc"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/opennlp"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
