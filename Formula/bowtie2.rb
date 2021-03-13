class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.3.tar.gz"
  sha256 "616017bcc68fc178418575fe39ffde42fff811d0d071bac7b1e7650288e4d166"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "c419e9c0755e6c39afc6c00c108c357347f85caf90924fe34411d8e6fdf91873"
    sha256 cellar: :any_skip_relocation, catalina: "2cc14ec9a94276ccd871fe52bce8cf0681121a7122156bdce421433614643cf0"
    sha256 cellar: :any_skip_relocation, mojave:   "bd542ef51869c57d76a743a82c981dd3257def7172680eca2d5d58796df20ae8"
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
