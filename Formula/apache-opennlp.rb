class ApacheOpennlp < Formula
  desc "Machine learning toolkit for processing natural language text"
  homepage "https://opennlp.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=opennlp/opennlp-1.8.4/apache-opennlp-1.8.4-bin.tar.gz"
  sha256 "43636c5ad48cb8360f6704aa98d0746534b46ec428904c3565b7a50b8c477ecf"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/opennlp"
  end

  test do
    assert_equal "Hello , friends", pipe_output("#{bin}/opennlp SimpleTokenizer", "Hello, friends").lines.first.chomp
  end
end
