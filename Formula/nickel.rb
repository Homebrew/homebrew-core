class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/0.3.1.tar.gz"
  sha256 "c6a5c912b72fef91cee552445522031ffc5ebb6645e381a6798dd2415abd3d25"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8c58e9bbb85d740cad647e05603357343a942474e96b7be01ed5a23984d4b8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8d3d22ffed28278db6b4ef881d7ebbe4e9fe7c0bad18e1a2ae0e4c58c53d11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58cee1f20894ef7249bad91884db65763208b597c76cbe68fdd26be1df42edf2"
    sha256 cellar: :any_skip_relocation, ventura:        "51e4a070040c702360b6131dd106cdf2de3078a687689a775ed95b6f93028cb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ea41b988474dfd222987b7cb0a231cbc1645282751ebec4461974bcc8187e7cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8c06369ba7bd9fecba1e32e4284f074b7219fa48137786364c3968e384b3d5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55762abf64d626cb5ee66e2d20d98ed77b6a1ce2f7fe545d8d5e3930e61f6a3d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
