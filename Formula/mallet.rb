class Mallet < Formula
  desc "MAchine Learning for LanguagE Toolkit"
  homepage "http://mallet.cs.umass.edu/"
  url "http://mallet.cs.umass.edu/dist/mallet-2.0.8.tar.gz"
  sha256 "5b2d6fb9bcf600b1836b09881821a6781dd45a7d3032e61d7500d027a5b34faf"

  bottle :unneeded

  depends_on :java

  def install
    rm Dir["bin/*.{bat,dll,exe}"] # Remove all windows files
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
  end

  test do
    system "#{bin}/mallet | grep Mallet"
  end
end
