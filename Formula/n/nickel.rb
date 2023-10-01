class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.2.1.tar.gz"
  sha256 "c926dfab3077020cee306bc89078430c3a67c8f8351da5f2409c656e61d9b639"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc709abcaf3c23506389862245ca2599b0f44d822d93a2a4bddf0764bb470296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6b99b92c323594068a064748187af6fb7bf3c56ff4b1b0ec8d6ec7d982c037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18e26f36f2f5da35ab647f81a382d9f403ed2c6e7dcaab215c0728a9e3aadf9d"
    sha256 cellar: :any_skip_relocation, ventura:        "9beb56ccacd699224f97b7eda5af3c7456042e5cba28c6b76e53e42081da3700"
    sha256 cellar: :any_skip_relocation, monterey:       "77a13cb97e3a08297216677ca3dbb008ebee97b9b0c5a70b1bc02f77e8bec2ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b6025ff4a3472dd983f9bc9083f0990c150299abce4eebae98c8831716691be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01d017caf0e0b4717113c19d71b22049cb4a9d8daed63a22cf20533d04343bca"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
