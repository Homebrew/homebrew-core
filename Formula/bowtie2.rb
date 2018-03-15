class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.4.1.tar.gz"
  sha256 "872f2580221dcc9bb4a8e3d04e032c168883c4c529d0733e3d94fe693f7732b2"

  bottle do
    cellar :any
    sha256 "a6351c8bd99daf742dbe510df03219b47a90e142d2d8612d64d112a5c62820aa" => :high_sierra
    sha256 "e454334bb9c1526fbc153f8f98392424942b86d82fe7c90b108578896839fcd2" => :sierra
    sha256 "b6a3b49b0464d36330ff470ee0b4a4b10afbc763a8751804365b7d782cd23c22" => :el_capitan
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
