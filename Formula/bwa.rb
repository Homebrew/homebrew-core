class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2"
  sha256 "de1b4d4e745c0b7fc3e107b5155a51ac063011d33a5d82696331ecf4bed8d0fd"
  license "GPL-3.0"
  head "https://github.com/lh3/bwa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c21d941893a927b1f362fb0f44d809cc81b5d4ec59f4073b5f39d081902f321b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4340d5a65a5c146033ea20710f9489ef2fe2a3b2c85937f3e71da141c44d4658"
    sha256 cellar: :any_skip_relocation, monterey:       "815da042557c670364ad899e1257f51c893979436beb1c016c8fdb6ad9ef734a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d67267aeea4145fef5e65fe1c8d9f9b34121c0339badf703811027db2570967a"
    sha256 cellar: :any_skip_relocation, catalina:       "59b821b80f729fef923c3edb048478836c72d6aea34b245d1b292b2c3f893432"
    sha256 cellar: :any_skip_relocation, mojave:         "6b07cef5ea1955d8a83e7b59ef8458a7604998f735f0eab85889fa3aedc7e953"
    sha256 cellar: :any_skip_relocation, high_sierra:    "02da3eecd6569c193a55436f705c8d351d052e44b79a43d6afc50f7308603a73"
    sha256 cellar: :any_skip_relocation, sierra:         "4db97125930b495fc34b6d161bea57171ac4bf2a5bf48ca1088a69a594874710"
    sha256 cellar: :any_skip_relocation, el_capitan:     "bee09d138e9d8f45c12d6c99b48a3e6891b6e4d3f5c6a6847bfeaa28afc2f362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d875f0b64143cfb58e44681e47102158b46e0004c408d8fc5f10dc976383a94"
  end

  depends_on "sse2neon" => :build if Hardware::CPU.arm?

  uses_from_macos "zlib"

  def install
    # PR ref: https://github.com/lh3/bwa/pull/344
    inreplace "ksw.c", "<emmintrin.h>", "<sse2neon.h>" if Hardware::CPU.arm?

    system "make"

    # "make install" requested 26 Dec 2017 https://github.com/lh3/bwa/issues/172
    bin.install "bwa"
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nAGATGTGCTG\n"
    system bin/"bwa", "index", "test.fasta"
    assert_predicate testpath/"test.fasta.bwt", :exist?
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
