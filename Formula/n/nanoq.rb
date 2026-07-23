class Nanoq < Formula
  desc "Minimal but speedy quality control and summaries of nanopore reads"
  homepage "https://github.com/esteinig/nanoq"
  url "https://github.com/esteinig/nanoq/archive/refs/tags/0.10.0.tar.gz"
  sha256 "c6ab28a5c738be950bfbf36ddf9e0e46216a9a1aa040d6745fcb9d87cc32534a"
  license "MIT"
  head "https://github.com/esteinig/nanoq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f97e13a405da805711730cc25d984c95cf40736b4af80b5797545738eb9e602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6dbcbc1413f42a698bbe0c7d4c2580f2a69f86e57afc33ab621e7a86b7cbd9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d2910d13487782376995a77cfb1e784f3236bf9728eaface01237795161170c"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ee7a9efa26ebf011db446b04ba380514c6253df543bb9dda6a9604d0840ca1"
    sha256 cellar: :any,                 arm64_linux:   "dd89f62bd4def3fff1b79329544cd2134051ecff88feb5437c2f05bd29209142"
    sha256 cellar: :any,                 x86_64_linux:  "474d85796391810c1f784401e31fcdeaf5b459b179feeb5e5adaeec25bddc524"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.fq").write <<~EOS
      @read1
      ACGTACGTACGTACGTACGTACGTACGTACGT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
      @read2
      ACGT
      +
      IIII
    EOS

    # Filter out reads shorter than 10 bp; only read1 should remain
    output = shell_output("#{bin}/nanoq -i test.fq -l 10")
    assert_includes output, "read1"
    refute_includes output, "read2"

    # Verbose summary report should count the 2 input reads
    report = shell_output("#{bin}/nanoq -i test.fq -s -v")
    assert_match "Number of reads:      2", report
  end
end
