class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.1.1.tar.gz"
  sha256 "48f709d5c21c9961bfaaf7a1abc766fc62909afd249e8cd104f72d2a68df601e"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "276e04824cb230e1be7d64ac60d7f3a0732735b3ba5fc42a8beaded9a618cbc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66c084ddaad46bfc65878b0bd644ca65ba24ddaad661dd812cf252ec8978b72c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "589a92efc3fc2eba9644e6636654b3f8d2c51d6889736ec123a49b22ac5fd6d5"
    sha256 cellar: :any_skip_relocation, ventura:        "ed7ad80678db0458906fbdf386c8b33b80439769a74d0ce340943930715abab3"
    sha256 cellar: :any_skip_relocation, monterey:       "67bfe9f283b334d266fc1ef7eaa2df92c3206247998a212f811acd0c350202e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "53298e2707cc986e6e443aec7b3ddda0d338270764de287b2745dff29eb17f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4fe88a0b96556b6441986344140f9b9038cc25e0ffa8db26f8c6f3e7742cbe8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
