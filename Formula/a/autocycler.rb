class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "564018115c5c1da970e92059817f30e44370f621c18ec9ef3c8dba41605661cc"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2338ee10ff9888accef44fefe72b7175f36002567e661e81b1cb9e44e80409a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1acd7539d9fbc1473df082659ec95bbd15e718f2031ed16e0590aebc45399af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3ad9748d80c719497536fee36284bbbfdc0e14d4ba70f57d0b92222760cadea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7a8490f01216bec1f3f9da51310ff1641c3c99d4fed44660e43761ba0c6acd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe40dd292f0e1ee5d75353d1c56efb0d4fce184d731a00dd59a80b370e97653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5849ffa59c7c215e7027ec794ca1f15aa812a31e0ff1e9c2fed5a3def2bfe6"
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
