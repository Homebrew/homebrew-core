class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.8.2/apache-opennlp-1.8.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-1.8.2/apache-opennlp-1.8.2-bin.tar.gz"
  sha256 "cbc9640fb8f86bca398a562aa0f5d93c87e3966d7e6574f32628d8ea080ad5ab"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/opennlp"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
