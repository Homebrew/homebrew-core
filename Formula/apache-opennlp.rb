class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=opennlp/opennlp-1.9.2/apache-opennlp-1.9.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/opennlp/opennlp-1.9.2/apache-opennlp-1.9.2-bin.tar.gz"
  sha256 "26b55416a6c330e9c91bf9ad31183f3ed3104643b3d74ad2ee6e16b0c0e44f3b"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/opennlp"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
