class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.10.0.tar.gz"
  sha256 "5821c0aa5fdda9e84399a5f92dbab53be2dbbcd9a7d4c81166c0b224a38624f8"
  license any_of: ["Apache-2.0", "MIT"]
  revision 1
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e5ebeb79afe83fbd3574ac1f7215d31060516b60ca2641be8b8c815cdb29db6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd1b3f049527c0a9129fdf15d9e19efba0b5581956339f40f635838777ed651"
    sha256 cellar: :any_skip_relocation, monterey:       "b0257b995d1de194de33a15a3892f68b757a2f2f1a9b4516f5a661d90b838188"
    sha256 cellar: :any_skip_relocation, big_sur:        "129c0fcb8d127d18d3d8577031deff0a55686f65b50bd117accea0052e2aed72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e828b26c57dab9ea6bf999766a0ba2e863482e2b311f5e2920ee6c82614202f"
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
