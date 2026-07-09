class Elio < Formula
  desc "Batteries-included terminal file manager with rich previews"
  homepage "https://elio-fm.github.io/"
  url "https://github.com/elio-fm/elio/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "332ea7a7437f820ab732842f1674c9b8436e0b7c2a0dbece0a52155843a8001a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65b38652c83c2bf51c35603340734234c4b5026c91caf2b46719970eed9f2450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343a8356f54f37e8c9a4100aa21e61ddd646509e6ed9165ef527c3bb9a728da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a49255e78a02fa9ccd8b026bc6bf00d1c56e04f6af2be082aa0e2f2c54e3d27"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf3c2fd2928440c33a6e2718d1ff1618afa961ff7e5e1187d427669d56f92c07"
    sha256 cellar: :any,                 arm64_linux:   "5329acd975d14bbb2ae6202df023c5072ab07d61e702186b419bc7408d271ba4"
    sha256 cellar: :any,                 x86_64_linux:  "93f04ccb7d7150bc07c5e3580d53f0e422b1ab574b1ecea069378806108a9fcd"
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
