class Hexyl < Formula
  desc "Command-line hex viewer"
  homepage "https://github.com/sharkdp/hexyl"
  url "https://github.com/sharkdp/hexyl/archive/v0.13.0.tar.gz"
  sha256 "1b5d2fc49724a7ce76253f328190b9b5e09ba39af7ca1be9aa610c5c7e8c91b9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/hexyl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d71beeef937d49b297d9e7a76e7f45208ac9fd58b9fefe3651e3861ee0ee2d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de6a97270311eccdab8ce0c6d6c949c3d72b86293912806f2694d83db57761c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2add75cdab2255289b6622c3b4f2a6d635ff6754530debefb0729dc7549173ba"
    sha256 cellar: :any_skip_relocation, ventura:        "befc2458954e169d52ebfd337ded05abef0e272ad1de607581f8ebae3f949b51"
    sha256 cellar: :any_skip_relocation, monterey:       "63506de15a78008b27bbcce9d747a7c9303fa8994fe96eeeb2650e9d7b35d2f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9802f516070205543e4927c77e7fcaf1e8d82cf9650d5bfc31c0c8cb8ce728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68dea9fe9f2bf03488c3786ee790f5c98fda6d26e683a34d53d3afc234fcac13"
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
