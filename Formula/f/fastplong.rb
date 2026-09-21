class Fastplong < Formula
  desc "Ultra-fast preprocessing and quality control for long-read sequencing data"
  homepage "https://github.com/OpenGene/fastplong"
  url "https://github.com/OpenGene/fastplong/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "29cd6545d0db00e4a53989088dcdb7b0f0dcbc4442574fb1b5f67b594df7cb5b"
  license "MIT"
  head "https://github.com/OpenGene/fastplong.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b19af367fd97514e55d41079b2abc53eed849ebb2b2e1e0022b082966250e5d6"
    sha256 cellar: :any, arm64_tahoe:       "9902ccee778382b88435ff5c3bc3c75d35af206f233c6e5a1bd0c5704a037628"
    sha256 cellar: :any, arm64_sequoia:     "f49674cd5ab99ba7c3a1b1a795176e5c7220e7a8f8d85e3a36e3f98616e91e6a"
    sha256 cellar: :any, arm64_linux:       "5105f4015bbcf3505ab6ddf477dd541f407a59d5e617e9f815f15536114a0c0e"
    sha256 cellar: :any, x86_64_linux:      "67b9bdc45234dfd2f6f771db730ddb3c93f3c60a43312b8c91c43385c4b6b4a7"
  end

  depends_on "highway"
  depends_on "isa-l"
  depends_on "libdeflate"

  def install
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
