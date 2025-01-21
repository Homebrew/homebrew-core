class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https://lastz.github.io/lastz/"
  url "https://github.com/lastz/lastz/archive/refs/tags/1.04.41.tar.gz"
  sha256 "ade7c8619e1f83aae1b1e6e16a9bc74d283756565f0bb9f6a6ca28f8d862227e"
  license "MIT"
  head "https://github.com/lastz/lastz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249337411a2223d7f7ee95924d423e7683bcff9b571359389d58eaae99749a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b85092ed452764b74babb30fb3946385b52bc5ddee17596cc8da60fd9b65919"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec14cbb84beb440df19bbc51ce5ea1dcf2471634cc3c3045087fd7723043aa56"
    sha256 cellar: :any_skip_relocation, sonoma:        "41587e47d108426ce7b08e07388d41d65c4463f5bb52aea00691cf6ad65f49d1"
    sha256 cellar: :any_skip_relocation, ventura:       "b841bdcbdd690d8f6ea78f42a747e1950e666dea691be901ecf4c9858b5b3b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b8d64d120c976a50b01d5430607295a4e5a9668b8e4b5cca6a225dc8371085c"
  end

  def install
    system "make", "install", "definedForAll=-Wall", "LASTZ_INSTALL=#{bin}"
    doc.install "README.lastz.html"
    pkgshare.install "test_data", "tools"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lastz --version", 1)
    assert_match "MAF", shell_output("#{bin}/lastz --help=formats", 1)
    dir = pkgshare/"test_data"
    assert_match "#:lav", shell_output("#{bin}/lastz #{dir}/pseudocat.fa #{dir}/pseudopig.fa")
  end
end
