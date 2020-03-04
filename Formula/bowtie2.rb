class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.1.tar.gz"
  sha256 "9fb25513886bf294217dd9c5ca26d18dd5e02e0ae999935ac7ba5700befc492e"

  bottle do
    cellar :any
    sha256 "fd107ab602165eac36dc748124cc6688f8eccf63ff9a64ebcf82fa4db45b5788" => :catalina
    sha256 "ca70730942c77835fc3ee267dd6c284d51351af0f59db282876ca9ada2ce4672" => :mojave
    sha256 "61597b46c1e6bd55d74c89e107342c4bdb5014d3a7ea37628d544b6f429bef9c" => :high_sierra
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
