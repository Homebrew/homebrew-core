class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://github.com/JuliaLang/juliaup/archive/v1.5.29.tar.gz"
  sha256 "4dc02d9e7ecddf7364b1862d8b478c2a6f01e0eea9dd755e40e171c42d0b3511"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abdd9330ba64268bc423074e7eb2590217d0fd6c7b6d2a8e8c02f57173e3f08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc4e55e31e154e154b51c04a0cc9569238d72eb1cbabc2c1d0d93327dba79d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "0a83fc481ff486512f68274ba1d4b1e32d51884fe9bfb00c69c8be6a7e7e1715"
    sha256 cellar: :any_skip_relocation, big_sur:        "bae0cbf1754d380b7d0f594671689ef808dcb57c1221e58f134d9e1b33712631"
    sha256 cellar: :any_skip_relocation, catalina:       "94046034cb965550392a3ac37bdc03cf66d071c1847fdb022b6fbcb653261aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35b2e8360ba2cb813f0f5359cbe2472d8a5c22a2ae106a38c84732743d86fac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end
