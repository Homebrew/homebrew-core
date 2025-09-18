class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "52853b4edede889b40fd6ff132e1354d957d1f26ee0c26ebdea380f8ce82cb0b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c15731c7c84f60dfc4f741663937e78951f846bf5c31fe78c4a3baf5a2af934e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97598fb11f5c1a101081183f3a00864973d5349402864db0e2c694a48c079f97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21cada0c4349bfc09a426f2616e4f881ef42d6625d46120d65f95394e2e36fb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779a6fdb3c0f2e6510bd57178035273a0f9646f5040d7a5f62c71b6acfe40242"
    sha256 cellar: :any_skip_relocation, sonoma:        "61036a4e637cedfd6552216797444bf1bf0cbd1d2904fa45be32ac595cfbcb78"
    sha256 cellar: :any_skip_relocation, ventura:       "42429a6a91e2d1f963559a9c618397be4ab0fbd70e206c599e49acab065cdff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80fe3aabca5af968a98011d4eafacf571e107ef9650342a293f9585de3980009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ad345fa48b2ea4a6e62145423924a9f4112f10b1cfd1f765bdb7b3531d56c5"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "pandoc", "-s", "-f", "markdown", "-t", "man",
                     "doc/hexyl.1.md", "-o", "hexyl.1"
    man1.install "hexyl.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/hexyl -n 100 #{pdf}")
    assert_match "00000000", output
  end
end
