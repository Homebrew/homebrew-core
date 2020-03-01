class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.1.tar.gz"
  sha256 "9fb25513886bf294217dd9c5ca26d18dd5e02e0ae999935ac7ba5700befc492e"

  bottle do
    cellar :any
    sha256 "9f172b2f1e1a3109804f6b6e025c236b8a2b15bcd36fb3e06efee112208c9644" => :catalina
    sha256 "d7d7155e0021c3907424e52f556314129eb214fd703c88e3c164c511ec669a73" => :mojave
    sha256 "57ca0fb7b0c670fc2bf699abc7edb5912dc89d6b7dfb7f572beb163585580471" => :high_sierra
    sha256 "23ad887cdf7c6154399b708798f339731fdfb7ec514d8026a51c2ae8ce866a4c" => :sierra
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
