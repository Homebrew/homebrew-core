class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "http://mallet.cs.umass.edu/"
  url "http://mallet.cs.umass.edu/dist/mallet-2.0.8.tar.gz"
  sha256 "5b2d6fb9bcf600b1836b09881821a6781dd45a7d3032e61d7500d027a5b34faf"

  bottle :unneeded

  depends_on :java

  resource "testdata" do
    url "https://github.com/mimno/Mallet/blob/master/sample-data/stackexchange/tsv/testing.tsv"
    sha256 "281c76b87c3fa4edc6d9c46a0660ceda74e9a76ac1855da563490b211265a7c9"
  end

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    resource("testdata").stage do
      system "#{bin}/mallet import-file --input testing.tsv --keep-sequence"
      out = shell_output("#{bin}/mallet train-topics --input text.vectors --show-topics-interval 0 --num-iterations 100 2>&1")
      assert_equal "seconds", out.split.last
    end
  end
end
