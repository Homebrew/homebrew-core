class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "fa1786133b95b7f011a6d4d743c07b3aea7c4f5633bc0d1d51a1758bbbc11157"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3f2db8518f2a3786e61cde1b2c8c52085648a3f059d4b171686be6b9bb91ec2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7da063e52064588d11ded0289c11524272ba0d94a6e17225176aca5b666961d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "629df56f080f548389db6c4205c34a072fcd5df24ee4bd00d5b76d2d11ded8c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e5b17aef25b5fad863e17b8f2f12c346a128bfc1b4f645922709267d7efb875"
    sha256 cellar: :any,                 arm64_linux:   "4a2d2dcbd3a3b1d6880325fbfd710ce50fe7eb2126703cba010c647a72b20a45"
    sha256 cellar: :any,                 x86_64_linux:  "438a5df202e40718bfde5f2d0158d2a335cfeb844e4a81d4b0dc754abb961c5d"
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
