class Chars < Formula
  desc "Command-line tool to display information about unicode characters"
  homepage "https://github.com/antifuchs/chars/"
  url "https://github.com/antifuchs/chars/archive/v0.6.0.tar.gz"
  sha256 "34537fd7b8b5fdc79a35284236443b07c54dded81d558c5bb774a2a354b498c7"
  license "MIT"
  head "https://github.com/antifuchs/chars.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e86820c61f169941a6a3dae1cfcb6c1482cf8d3c085ce6efbf667bdbe1cfe894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "213905dc7e59d0347209f84242f9fbdc7dd1adea7f890c9668472b3b5389ec74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46c98e22e7a51a614c1dc0d91843e864571c06a89b9776097f2d69dbc863d041"
    sha256 cellar: :any_skip_relocation, ventura:        "0bf1197ee210cd14d89561b1e5bdc28947774cceba426eb04fdcf9984d30893d"
    sha256 cellar: :any_skip_relocation, monterey:       "f6a1f04b6483546d3290e6205425b9848f12f6649245138a81855ea64f45ecb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f269cd28454df1e15bb292be55d98c2416c82bef436bd0328b74db74abc4058"
    sha256 cellar: :any_skip_relocation, catalina:       "da663c9240e79d35e7a6a1cd40a114f37eef27e533126bca685af48b75fa11ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2612efe435bbd11443b34bc4a3dffecbc9036884ce64e9c6fd5ad32e65c767e"
  end

  depends_on "rust" => :build

  def install
    cd "chars" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    output = shell_output "#{bin}/chars 1C"
    assert_match "Control character", output
    assert_match "FS", output
    assert_match "File Separator", output
  end
end
