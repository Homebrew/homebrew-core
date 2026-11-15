class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "033ab877f00b01ae226bf3c20756883c8f97d1e44e682cea1a30723769d79cbc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c07f204da2d05f7cb001ccaf12fa4fc76e86cf53bb6a20cae2ed8db835b1406"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed347d8ddebe01bb425cc2b3135ae48a6611c684cf9139a87b45a246d1fc3dce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d90bd1c323ce9995bd29873fe5e80e0a6eba8f7090f124546923ec32d574ce04"
    sha256 cellar: :any,                 arm64_linux:       "f4287662145b193a04b24f03ecc7e69b5e45ed1e45d4f9567d8fcce2ed918ca1"
    sha256 cellar: :any,                 x86_64_linux:      "a49227111f374185df3b44aafc1f20a9c17f2862ebcef49082b1d677db6acb34"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
