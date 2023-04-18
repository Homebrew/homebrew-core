class Bkt < Formula
  desc "Utility for caching the results of shell commands"
  homepage "https://www.bkt.rs"
  url "https://github.com/dimo414/bkt/archive/refs/tags/0.6.1.tar.gz"
  sha256 "01ae0983eb199d2abd027e2b7b160c870d89477afdee2c5281faac4740814607"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565bde22f3681c85933ffbd44c18fc8735866ff6bfc8ba21b557461aca1ac5f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2417842bbd0988c6696ce3991833121ff8e65f3460180037e6e1b90722d3c327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e95bfb0699da1275a4179f29841fdf240f3bd8eea867b7e9aa58d7b2cd65f2df"
    sha256 cellar: :any_skip_relocation, ventura:        "17c00a7a7f2c7d2eb1d51fece94a383d7fc2afb9ed3a38b4d3a9c8040fde7751"
    sha256 cellar: :any_skip_relocation, monterey:       "fa79aa546022943ea1d4e62a8417215d2608f9b592cce01b044f37687c1beb26"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bc5eafbcc4fdbe55d5e6dab094a0c6dc99966070d3aa6bb0f1ad59c34daa317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eebf5d4b7f0a6efc825ea3317a5455765fb384eef399d321e663f44702f02567"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Make sure date output is cached between runs
    output1 = shell_output("#{bin}/bkt -- date +%s.%N")
    sleep(1)
    assert_equal output1, shell_output("#{bin}/bkt -- date +%s.%N")
  end
end
