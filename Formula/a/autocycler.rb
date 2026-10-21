class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "19bde509dee7f972b171b230e471f5cfec651cf6341dbb0a6f91458aee801550"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f64acab88516e134c934f69a438a77545d4c67e097fa4bdd306a608e1d401a21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0748c366e780d31d525d222433384c027c41e09cdf384ea986959c0287c8122e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "158a9115d7fc2d00a81bd908219d6a7945ab285fd31332e25d9b1cbee69bdf83"
    sha256 cellar: :any,                 arm64_linux:       "c5e52202ede956138b5881b329f42927e051def595f658d6a3b13fe75171e4d2"
    sha256 cellar: :any,                 x86_64_linux:      "3ce380cce8038843a3f26e1946dc29fec0a71bbb3bfa81505c1beb887b15a168"
  end

  depends_on "rust" => :build

  resource "autocycler-demo-dataset", :test do
    url "https://github.com/rrwick/Autocycler/releases/download/v0.1.0/autocycler-demo-dataset.tar"
    sha256 "70a5480b4390b2629a9406aad788cb2813570827b86b37b982609e6842ba0bc9"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource("autocycler-demo-dataset").stage testpath
    system bin/"autocycler", "subsample", "--reads", "reads.fastq.gz",
                             "--out_dir", "subsampled_reads",
                             "--genome_size", "242000"
    assert_path_exists "subsampled_reads"
  end
end
