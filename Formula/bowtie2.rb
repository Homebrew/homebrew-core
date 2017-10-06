class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.3.1.tar.gz"
  sha256 "8b9c0b9c595ebcddcac5feaf6acb44b2294d6deb91de107596ecad242a1a58e9"

  bottle do
    sha256 "3fe6f32e4b86211b5f2ba0f75a1f3865501b70ed2d474c54b335b24ab93313f3" => :high_sierra
    sha256 "3439ab26ff7b2952b7b39045d24988278d867d6f5ee2f3f61a4bbf787724a9c9" => :sierra
    sha256 "2ff5ef492d7df5d5de27751ff878937edc80d5e495213a868d48d994877a6151" => :el_capitan
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
