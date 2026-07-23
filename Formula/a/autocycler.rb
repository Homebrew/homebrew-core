class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "5bb281c3216ac266fc17fcda74b99fea11fdf7b01b5e32656d515fe470109efa"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "992c57a6d5450bd056c6d2b2c24abfe48dd85345e3b004880a76289905a93f25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "604db7c2318fc65c3813d71d61e0aab5ead0316eca804ae13f8113d167404859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e262907995fb18d6fe68ff1a642b4c1513bc11d44a7790cb0f5fbb20ed08dd2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e621bb15a01a2b15f6c1fe7f29893a6f01b99de987a39306b17a2733c8969a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d3294922ef49653594a3054e7ec3d0b2767116cd2c2b8ffa00ac3df46d8e224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "395606458ed7d83794cd484a80869682968eeb4f097dd5ce7c3ba0da8d500b4c"
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
