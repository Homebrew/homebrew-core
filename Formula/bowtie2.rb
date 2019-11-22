class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.5.1.tar.gz"
  sha256 "86a018af1090900c160a0990cc106569805aa64a3ec8708e1d2127839e4a94b4"

  bottle do
    cellar :any
    sha256 "9f172b2f1e1a3109804f6b6e025c236b8a2b15bcd36fb3e06efee112208c9644" => :catalina
    sha256 "d7d7155e0021c3907424e52f556314129eb214fd703c88e3c164c511ec669a73" => :mojave
    sha256 "57ca0fb7b0c670fc2bf699abc7edb5912dc89d6b7dfb7f572beb163585580471" => :high_sierra
    sha256 "23ad887cdf7c6154399b708798f339731fdfb7ec514d8026a51c2ae8ce866a4c" => :sierra
  end

  depends_on "tbb"

  def install
    tbb = Formula["tbb"]
    system "make", "install", "WITH_TBB=1", "prefix=#{prefix}",
           "EXTRA_FLAGS=-L #{tbb.opt_lib}", "INC=-I #{tbb.opt_include}"

    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
