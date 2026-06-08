class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "62ba4c02b4b86dd56ccc8c8c0ec8728f0f159f1107cea37e27a02ee4b54de7bb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca901ca2a9ac15e8a47b88ea375a5f547bef5d844761984d502651cb0fb98a8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b176a2e9bed1a272f9443755ddd8508ec931e04397ced2ad1885afe86858a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ba16f4db85a9be1591d0085fcd86d78f39546abaf5a4ff3c918722aa275a0f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd80d1031837879ecea24efe2b5f60d3d584d5b1d2649a7f6d51dc29a346f80c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b512e105675e0c8e0a73ac5c40e1841862c3d8bcd39e89deb15002c651542937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ccda4728813e88fd2bf47c71434fc4aecc652e6413e026d97738d1f250de679"
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
