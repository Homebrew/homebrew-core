class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "28c0537e9d1f32f5a5c404562e6a282bf373b034a4c3a3610d9aa31d6429b550"
  license "MIT"
  head "https://github.com/OpenGene/fastp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7b18c03f4b78f860f7a59a04898a97faf07a32c9380c286dcdac0648768c0ec5"
    sha256 cellar: :any, arm64_tahoe:       "995312e7f01fa658e4d2c4d29c0350819fc48d2bcd00a37a51c82c867fab4f55"
    sha256 cellar: :any, arm64_sequoia:     "fe550341fb5db9415ef784843397dbe04f26459ba5d14c2707f5bcb3bc30581b"
    sha256 cellar: :any, arm64_linux:       "c68f24192b8fe96ad6a239682aa88c518794dff09539e22e740d1edca7c0b937"
    sha256 cellar: :any, x86_64_linux:      "2c5c87a9f9aa944f14f022ee4eabe31f0ce0bb030448887a6d09cfbb46fe675b"
  end

  depends_on "highway"
  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_path_exists testpath/"out.fq"
  end
end
