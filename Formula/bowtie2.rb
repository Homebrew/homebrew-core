class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.5.tar.gz"
  sha256 "c5daeb0249e98dfe8f70dac7d660b100365a00a22df4cad94d3e383f489911ae"

  bottle do
    cellar :any
    sha256 "a8d3ff5aa29ef48837b1e1867d5ae015773f1e6a40a3fce5191ddc3211c709c9" => :mojave
    sha256 "2d0d7ea055e9e43276ccc0e88c24dbc013c2d008102f69415c601f2f2ee88ec0" => :high_sierra
    sha256 "6eb09792f58222c4c05354423647a694d7e7333479d279b2e3a14e5c13696511" => :sierra
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
