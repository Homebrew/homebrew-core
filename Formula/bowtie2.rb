class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.4.2.tar.gz"
  sha256 "2b68b0382ee83b203242dbe63eef20bd1b1a943f6eacbd6108883a01dc7dd148"

  bottle do
    cellar :any
    sha256 "d310255cfed149dfab02741be5b9e41ba13de9943532e1a050929d274c461b3e" => :mojave
    sha256 "a20ee3909ec4ba508ba71bffe0913a2e44577bfef41e8cb059290ee18560f1f1" => :high_sierra
    sha256 "a2482389d77ba4e401eaa81aa4f7d9b4ed9b080ba05701e2145a99e322558f35" => :sierra
    sha256 "49403b03c0b48aa8aa30b61c57ef125c4b6c61e829a536be7d99df476762ffaa" => :el_capitan
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
