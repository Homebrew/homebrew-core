class Fastplong < Formula
  desc "Ultra-fast preprocessing and quality control for long-read sequencing data"
  homepage "https://github.com/OpenGene/fastplong"
  url "https://github.com/OpenGene/fastplong/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c0afdf30f06e61e9837de30377894074b108cbd79b7a018501545806878e2b68"
  license "MIT"
  head "https://github.com/OpenGene/fastplong.git", branch: "main"

  depends_on "highway"
  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"reads.fq").write <<~FASTQ
      @read1
      ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
      @read2
      TTTTTTTTTTGGGGGGGGGGCCCCCCCCCCAAAAAAAAAATTTTTTTTTTGGGGGGGGGGCCCCCCCCCCAAAAAAAAAA
      +
      !!!!!!!!!!##########IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    FASTQ

    system bin/"fastplong", "-i", "reads.fq", "-o", "out.fq",
           "--json", "report.json", "--html", "report.html"

    assert_path_exists testpath/"out.fq"
    # The low-quality head of read2 must be trimmed away.
    assert_match "read1", (testpath/"out.fq").read

    require "json"
    report = JSON.parse((testpath/"report.json").read)
    assert_equal 2, report["summary"]["before_filtering"]["total_reads"]
  end
end
