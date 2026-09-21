class Chopper < Formula
  desc "Filter and trim long-read sequencing data by quality and length"
  homepage "https://github.com/wdecoster/chopper"
  url "https://github.com/wdecoster/chopper/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "899c3bb3e20da9b5ac232b413033dcc26e09c71f3aa222498ba25f4241fed56f"
  license "MIT"
  head "https://github.com/wdecoster/chopper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dac1aa58a3a38cd42e86addc86c9c19366d80be11b47317f32081f5b06e052a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e8297bccef0beca9b51bb57c99515359b92fa5bb08cce07ed1759bacf38b595d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62dea61fc25b6cc5e87eeb61228175501d10cac64a7df8a2e0a2be015f27d843"
    sha256 cellar: :any,                 arm64_linux:       "9980667acdd61bd2aa6f492b6d83e9d0bfd5e8af45d19a67e32c1932ac012f5c"
    sha256 cellar: :any,                 x86_64_linux:      "5d90c0f6c78cf90a25483a2f07d87fb5080d929855bbbcad47072916f3a388e3"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # read1 is 32 bp, read2 is 4 bp; filtering for reads >= 10 bp drops read2
    (testpath/"reads.fq").write <<~EOS
      @read1
      ACGTACGTACGTACGTACGTACGTACGTACGT
      +
      IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
      @read2
      ACGT
      +
      IIII
    EOS

    output = shell_output("#{bin}/chopper -l 10 -i reads.fq")
    assert_includes output, "read1"
    refute_includes output, "read2"
  end
end
