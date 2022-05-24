class Lastz < Formula
  desc "Pairwise aligner for DNA sequences"
  homepage "https://lastz.github.io/lastz/"
  url "https://github.com/lastz/lastz/archive/refs/tags/1.04.15.tar.gz"
  sha256 "46a5cfb1fd41911a36fce5d3a2721ebfec9146952943b302e78b0dfffddd77f8"
  license "MIT"
  head "https://github.com/lastz/lastz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e903d2a69b8290e6c86d8b810ba79b60dc66eab4de6ce6718275961ed50688a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de52a79ade29a7db8f36ca3e808b9be5900d1839e44a365380a4eb6894c2636f"
    sha256 cellar: :any_skip_relocation, monterey:       "07a446a9b0c6c3cd6942cef9cfc6aecad41b4cfabfedb9a1bb7440bb8c660e6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "57b09f05e5c56455f4d111807f4a2ed93d1d27d2e6549920bfa08dc37655b694"
    sha256 cellar: :any_skip_relocation, catalina:       "65e45afb94391221588f6abe49ef096a45dec40c7cb23d038aa50c9a238a3c24"
    sha256 cellar: :any_skip_relocation, mojave:         "42436ebd92ce29d3981ea1d2ccd61a9ade9739866fcbb3e004bb53ab3b45299e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ebb95d9d902213839542914bcf1dfb2504f6af458a50562214855b39139481d"
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
