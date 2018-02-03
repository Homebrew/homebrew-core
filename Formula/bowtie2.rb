class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.3.4.1.tar.gz"
  sha256 "872f2580221dcc9bb4a8e3d04e032c168883c4c529d0733e3d94fe693f7732b2"

  bottle do
    cellar :any
    sha256 "954c729dfb76a753d31c2b40dafd543c617930572a903e06d57bdc171a74557b" => :high_sierra
    sha256 "483e1f18fed745ea4aa74aa7ad8d3e2c59aff63715d624b8526c2fb5d5137f23" => :sierra
    sha256 "51174c043be22d4fdd241d94aa718eae53b5d60a8aafc4d023658938e3c421bb" => :el_capitan
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
