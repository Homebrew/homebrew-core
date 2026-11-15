class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "086e307fa45978ceac16c4916e36455d8796a930acc4d6ec911ca3e034a81c23"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "97b3c91f4fe5d4368d2e43152e74eef0712dbe918156db03b0cede19594796ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dbfd910f9d141af573222e4e54ca5b7df9b965a23f86405565c975ff4ee002da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9517eaf0df3c86c836c80f337a57b016fcccd1c5bdb632fa3c310d1ef84a57e5"
    sha256 cellar: :any,                 arm64_linux:       "858fc9dd777b61a8872b9baf78ec8b33fa682cdad2f370803e7092eaaa50d3e9"
    sha256 cellar: :any,                 x86_64_linux:      "cd33b5123a9e3e4347544904c32cdcceeb4729af6f200e8bb7cf7800f13a89d1"
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
