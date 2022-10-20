class Datafusion < Formula
  desc "Apache Arrow DataFusion and Ballista query engines"
  homepage "https://arrow.apache.org/datafusion"
  url "https://github.com/apache/arrow-datafusion/archive/refs/tags/13.0.0.tar.gz"
  sha256 "c68ae32b7d7db85e1f7e839f14929b6e4c4f813bef8a8bd87a03752707422d6f"
  license "Apache-2.0"
  head "https://github.com/apache/arrow-datafusion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a41a9b57f2d0510a416880eff4364ed0c20e8815fba3608dbdd992f06eb300"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d413f71081f1f742ddeb734915ea9ed021a94f17c812f4da873fb6a63d61666e"
    sha256 cellar: :any_skip_relocation, monterey:       "a30d1e134611810b6be494c15649851c44512aba42ce78ff464704480e171be4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c38ba40bffd8a7f7301b2cb1a204ee7d5216f05519a4d3ad89b8329e34dbdfe"
    sha256 cellar: :any_skip_relocation, catalina:       "4888e58a0bfe41408aa605849453363a8cc78775053cae4976e0a7b978213096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064b1d14d5f4af1dd00a732b1e29023586b6a783eaa071581e9eab72e4c9b440"
  end

  depends_on "rust" => :build
  # building ballista requires installing rustfmt
  depends_on "rustfmt" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "datafusion-cli")
  end

  test do
    (testpath/"datafusion_test.sql").write("select 1+2 as n;")
    assert_equal "[{\"n\":3}]", shell_output("#{bin}/datafusion-cli -q --format json -f datafusion_test.sql").strip
  end
end
