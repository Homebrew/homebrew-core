class Autocycler < Formula
  desc "Tool for generating consensus long-read assemblies for bacterial genomes"
  homepage "https://github.com/rrwick/Autocycler"
  url "https://github.com/rrwick/Autocycler/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "5af439e1855be4c32564a1f33b25f9c7450289fa1a344442cc6de6e87b989553"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Autocycler.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ede7e242dfbba625b3bde0450dc87aacc2f459475293dfe12ece8bca7169613b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b2edcb09b305ea8e80759eb98d353ceacc37ff9d2f2d3b5cb24916319dcac87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2de6a1cf2213fd09d4850e2dff852199e97b85f50520e36dc8674facc2daf01"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b508cb94d40267b3a2be22846f79f132c2aaa34e9a217f6ef78a5f73155fd2"
    sha256 cellar: :any,                 arm64_linux:   "abd8e3fe9c38a98ebee037bee2208448121b2aa770003466715a75803e5cd58d"
    sha256 cellar: :any,                 x86_64_linux:  "27fb2901b4a9b9378a3e741974ef89a823a201d37af4c3f850584d706b9604d8"
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
