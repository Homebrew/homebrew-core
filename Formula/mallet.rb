class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "http://mallet.cs.umass.edu/"
  url "http://mallet.cs.umass.edu/dist/mallet-2.0.8.tar.gz"
  sha256 "5b2d6fb9bcf600b1836b09881821a6781dd45a7d3032e61d7500d027a5b34faf"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  resource "testdata" do
    url "https://raw.githubusercontent.com/mimno/Mallet/master/sample-data/stackexchange/tsv/testing.tsv"
    sha256 "06b4a0b3f27afa532ded841e8304449764a604fb202ba60eb762eaa79e9e02f3"
  end

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix)
  end

  test do
    resource("testdata").stage do
      system "#{bin}/mallet", "import-file", "--input", "testing.tsv", "--keep-sequence"
      out = shell_output("#{bin}/mallet train-topics --input text.vectors --show-topics-interval 0 --num-iterations 100 2>&1")
      assert_equal "seconds", out.split.last
    end
  end
end
