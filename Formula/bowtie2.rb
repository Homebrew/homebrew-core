class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.5.tar.gz"
  sha256 "c5daeb0249e98dfe8f70dac7d660b100365a00a22df4cad94d3e383f489911ae"

  bottle do
    cellar :any
    sha256 "c9c2753e56da817661b09b4822f2ec1e1eb00c429633424e2a502dbf29880495" => :mojave
    sha256 "562800996db7ebac416557a1975f73dbf37b670bf86bb16e4ff5facb2bd69ef0" => :high_sierra
    sha256 "95abc01c20f7f0d6db733f3f21ef8b4421e7bdbb22c919d7776933bec30d81e1" => :sierra
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
