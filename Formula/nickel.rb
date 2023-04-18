class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.3.1.tar.gz"
  sha256 "c6a5c912b72fef91cee552445522031ffc5ebb6645e381a6798dd2415abd3d25"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6a915134c3291822bfe08067c29647d3a3fa0bd8a64709abd0dd4a7ef87bd56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac71ff7ccab3e571e09cbd963dd38f07752b1cff24b9087a717edd97adcdb4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27a3c77521a95f6caefb8109c55d0291fceb5ff0ed18b81e2bed40726fe088a3"
    sha256 cellar: :any_skip_relocation, ventura:        "02b746d98e6838c1ec2e7c38abd7ac6f0a4141fd165cb5bba053c8461744b2de"
    sha256 cellar: :any_skip_relocation, monterey:       "92aa4f7a6086a1c2fa0647b44d39ecf5de2d832839c39a39cb968294f3065827"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb921ce652f1e8ebff8e1df9a70dbd89cc26d7dcc4619161d673c8d852797fb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d4c38fb6f39012dba5fc1cd6d67197b698ff47cf70eb46db5f6697ab51a565"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
