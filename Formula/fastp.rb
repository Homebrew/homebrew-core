class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/v0.20.1.tar.gz"
  sha256 "e1b663717850bed7cb560c0c540e9a05dd9448ec76978faaf853a6959fd5b1b3"
  license "MIT"

  def install
    system "make"

    bin.install "fastp"
    pkgshare.install "testdata"
  end

  test do
    system "#{bin}/fastp", "-i", "#{pkgshare}/testdata/R1.fq", "-I", "#{pkgshare}/testdata/R2.fq",
        "-o", "r1.fq.gz", "-O", "r2.fq.gz", "-h", "fastp.html", "-j", "fastp.json"
    assert_predicate testpath/"r1.fq.gz", :exist?
    assert_predicate testpath/"r2.fq.gz", :exist?
    assert_predicate testpath/"fastp.html", :exist?
    assert_predicate testpath/"fastp.json", :exist?
  end
end
