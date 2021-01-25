class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.2.tar.gz"
  sha256 "ea33a1562faf759b21b3a905e20b87a3524ac4e53af8cd723d9a9f31ee159c8a"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "5c80e63961045e5f2fa1df91a8d6b16d4c50c68db3cc8cba861c7235403e0119" => :big_sur
    sha256 "1fad17bb5fbdcbb626dcbdd236b41e7a0731099fe1960938aba01b6c1bf36d99" => :catalina
    sha256 "c3dd293bb8d6045279ba6673cba40efed562e26746c62b032d174c9fa72b049e" => :mojave
    sha256 "622aa5c50e75a72811b6f843bda9685d71d6a764af887641252226f7174ce4b6" => :high_sierra
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
