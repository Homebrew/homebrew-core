class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "303d469b2ec432d7ff4a2eaaadbf532decd0a1f2852a7c83cc56c3fd164290e3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "887269ac72342116194c94e2ae5ebffa587068044d45da9a2670a1fa74c3bd64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b09d560cfaf596ac860756e5b2f01aa7b7c0193c5c35f48d58f122183c8418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07379e2508a5f16470d9753cd6be6e09e06c9be2f9844b1ddd80d759f7f70108"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf64c3c1dc0bdb7855e6e6cb639691124f3074f7a18ad81ce2f1c43659624637"
    sha256 cellar: :any,                 arm64_linux:   "06f1c6c18aac2b159a2169d0ab269bf4d5d3dacbabbf47f3a1b0b3373e7b5009"
    sha256 cellar: :any,                 x86_64_linux:  "9a6d9317d60a7a3029e891396acf31823f3a806f6d9be2596097501f4d104886"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

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
