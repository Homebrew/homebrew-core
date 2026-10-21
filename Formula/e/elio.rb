class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7a78b104e48f94a0460333a02f5e5f3a95dad11ec21a24e2b0be69d6e1974799"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66f1c8df7edf6f4461b5b3bc970245d68c37b65842d5341915c817713bd49a14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "60be7582ccbac8bbf475e793fda28b10e6a85e81babc8bb3eb365511f7a11584"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "616c24aa5d47021ed368f9a542770197be26d28b80d293e1ed7793f4f01106ed"
    sha256 cellar: :any,                 arm64_linux:       "7747ad8c9279265fb47fd3ebfaa46d1625cf212e6e7a2ed0a105c94b8c215ed7"
    sha256 cellar: :any,                 x86_64_linux:      "87b17e86497cc9ba478f1d1df0aca30fb417723134b8727e412f43c02fc0eaa0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    missing = testpath/"missing-directory"
    output = shell_output("#{bin}/elio #{missing} 2>&1", 1)
    assert_match "no such file or directory", output
  end
end
