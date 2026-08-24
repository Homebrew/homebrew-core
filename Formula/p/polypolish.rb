class Polypolish < Formula
  desc "Short-read polishing tool for long-read assemblies"
  homepage "https://github.com/rrwick/Polypolish"
  url "https://github.com/rrwick/Polypolish/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "4e00dce9e3c1a224fdfe16b0e3632df13a250f43a36c302fd579683bbd325086"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Polypolish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "724a91cf5a5c643e6e0819b1687b43f4f25a1af38c3c436333b3c4b4e6cabccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7918f4245759e261e3d4d18bdf806bbcb33e6c4e80273e73c432d5f138fa060"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68610b6f5c691726bb9078465ab96f0b29368712896c586a4a0a0a8dc1ae90ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "caceac9f5ad554a14137c1195308563578e89cbc978eed1a7d13de7875759636"
    sha256 cellar: :any,                 arm64_linux:   "b8ecdc28a784dc720786176e2750a81fe0e1d33bca54391604d98c7db799f10a"
    sha256 cellar: :any,                 x86_64_linux:  "a98d659d9bad3917ee3fe7447d246107e58ec51c73ee879b21c4fac90fdb45e5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.fasta").write <<~FASTA
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    FASTA
    (testpath/"test.sam").write <<~SAM
      @HD\tVN:1.6\tSO:unsorted
      @SQ\tSN:U00096.2:1-70\tLN:70
      read1\t0\tU00096.2:1-70\t1\t60\t20M\t*\t0\t0\tAGCTTTTCATTCTGACTGCA\tIIIIIIIIIIIIIIIIIIII\tNM:i:0
    SAM

    output = shell_output("#{bin}/polypolish polish test.fasta test.sam")
    assert_match "polypolish", output
  end
end
