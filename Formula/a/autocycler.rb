class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "371e5815c7ed7b83c3b19d1282ce4b043bff0b23eb08a8dde4f5ff9ee73c31ee"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3df9155d8e46b0cc1b89041613195338c789e53a7eead38d4e6661af9ad3e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa67f52f7764946aa612e550637cdbd5368d313ec06a5b7f3d6a14a1e7ee9528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2e32d17ea27850c128bdcfb4589613939e373dd40fd9725e56bdc419f716cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b66dbe8d769d372409e6a40aa96c5d31862f8569d9ff7326617b70a700ec1cd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "19e655f41ded88da7769ca24dc50e1e5d7428a3636e39e9f7ffa7fa579fa58a7"
    sha256 cellar: :any_skip_relocation, ventura:       "619ee0a9c21f35454994d1e26e350421c17626cc1054d513dc38484ed398fc28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e06ac8cde8770a38eeba9e5fe67c4dc64b221fb9365f9e3b978d257a732af90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7f005447e399ff2d23451a9c0946f24d0d67892b4bb23171864771e4de46dd0"
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
