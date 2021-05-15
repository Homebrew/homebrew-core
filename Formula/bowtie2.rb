class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.3.tar.gz"
  sha256 "616017bcc68fc178418575fe39ffde42fff811d0d071bac7b1e7650288e4d166"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any, big_sur:     "5c80e63961045e5f2fa1df91a8d6b16d4c50c68db3cc8cba861c7235403e0119"
    sha256 cellar: :any, catalina:    "1fad17bb5fbdcbb626dcbdd236b41e7a0731099fe1960938aba01b6c1bf36d99"
    sha256 cellar: :any, mojave:      "c3dd293bb8d6045279ba6673cba40efed562e26746c62b032d174c9fa72b049e"
    sha256 cellar: :any, high_sierra: "622aa5c50e75a72811b6f843bda9685d71d6a764af887641252226f7174ce4b6"
  end

  depends_on "tbb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
