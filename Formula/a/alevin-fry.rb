class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "ec36543dd23041f46ffdbe9f0207c1301f72e6c03f4e017d5cde18be626868d7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9a36b05d95406546dff2f4e3cc3502e01c4f28ac42205ca15c0699a151ab3a5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34d63792fa533fc61d84d262a7510e56366af8e384488bcc0313914494959166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a5798f5800a54be0ad3e0dd939660d2e2197a0731f5a9f4a1cd1d682c71d85b"
    sha256 cellar: :any,                 arm64_linux:       "c4622736ad83a3a79442ef566c3f5c79c4a0d6b1d11cf3801750d431934d7adf"
    sha256 cellar: :any,                 x86_64_linux:      "a7a21d1d36459da062b8f0e7a18be2f0433b1d5dd4eda11cadf00d1da98990dc"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/alevin-fry --version")

    sam = testpath/"test.sam"
    sam.write <<~EOS
      @SQ\tSN:chr1\tLN:500
      r1\t0\tchr1\t100\t0\t4M\t*\t0\t0\tATGC\t*\tCR:Z:ATGC\tUR:Z:ATGC
    EOS
    system bin/"alevin-fry", "convert", "--bam", "test.sam", "--output", "test.rad"
    assert_path_exists "test.rad"
  end
end
