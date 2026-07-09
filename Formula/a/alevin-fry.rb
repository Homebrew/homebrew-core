class AlevinFry < Formula
  desc "Efficient and flexible tool for processing single-cell sequencing data"
  homepage "https://github.com/COMBINE-lab/alevin-fry"
  url "https://github.com/COMBINE-lab/alevin-fry/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "0186c76859abd164bfa9cd3f6b13d2b31d572aff83d11bfb7f536d74810089ef"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a39a6491998bb7085bd72a55cb2e839f43a4eaa8c06a9682b9064a6014f0c4d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7307ce2640ad5ad22fafb1baa6fe36d75beabf8a3c1cac6b64b1ac86af7d8392"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97120c75459fd01ab2a295daa5babd0567ebacd2a64ef65e16eccc61fd5b4c74"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f2f9e27459be8219007e27ea7b606bfbc87fb88f2e740e0182df186ccef7ac5"
    sha256 cellar: :any,                 arm64_linux:   "d38462ba92b6552d8f0d0ac1ed24082ce2c7ba2a4a1c1265fe9326e4bdf24f7e"
    sha256 cellar: :any,                 x86_64_linux:  "a2ae575b8cb987fc18c5bfe0bc0f43585b594841a868e52fcbe14f588404ffa6"
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
