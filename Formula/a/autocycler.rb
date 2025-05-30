class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "028586ba433ddb6a21e4159c5e9075423c2ac4b0c60fbaa4744358cdfebf7d57"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85ccc0eb7168ad90a9a199d5ce858b53967ee484cbf02ef6f67deca592a37835"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0969f41334ef0e8de7f958b7ab09143ec334c5a3edac84c211ad7abfd5fd3486"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "007926a3b46baa917a944c0d61964820bd8ab3779198f5c648f2a38bb5f211a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2afedeb613f52e319f265b5ebfc2f1ff7d58b7edccd49e9943a1a1bd1d6e25c6"
    sha256 cellar: :any_skip_relocation, ventura:       "fc87ea4795c07d2622573c26c4e0afff33ee7dfd3ee737b37cec90304cbf66bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14428d82870689581a4be308fdbeb12a87155c2e4402f1e3da68aeeda764ec5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aeab2771d3d4f19e0db987892f0f07c31ec06482c4ff0be352915f76fa2c1be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "autocycler-demo-dataset" do
      url "https://github.com/rrwick/Autocycler/releases/download/v0.1.0/autocycler-demo-dataset.tar"
      sha256 "70a5480b4390b2629a9406aad788cb2813570827b86b37b982609e6842ba0bc9"
    end

    resource("autocycler-demo-dataset").stage testpath
    system bin/"autocycler", "subsample", "--reads", "reads.fastq.gz",
                             "--out_dir", "subsampled_reads",
                             "--genome_size", "242000"
    assert_path_exists "subsampled_reads"
  end
end
