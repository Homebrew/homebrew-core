class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "4e849b29b387afc583856f24923b76052ad90e320c2caacfc6452e6d9deb6b14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be30e77e1bfd54ec577774b5d0af5cdeb1a1382ef0b3ec5a47b3c8eddb925bfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e36747d66cede9a79aca02afe7e5f567ddef441f3d9b3d9bc2c4163ad0f7d840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1740da9ba16ae71f66a803037eb335f878c331e0948da3abd6f6fa6f152d7e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c0b3ce7086706f8aad2acb4f8c437eb5f8ce1c307b012ffbb9e778511bd157f"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa205542aa035edb393e2b48d656fbe60c68a4aaa23a27ee4f845a03987d956a"
    sha256 cellar: :any_skip_relocation, ventura:        "f8c163d680de745e68ef331899b8c47073745726b2566a78fe41708ab8727dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "8c21e21b50b6477771784308bbc0cce506590368180bff2f86b9cc43b725d742"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b06d6295febce2263801c05637d4a341c79e17d3cf3134f6e3556f1282c0a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f72fdb2af6d6939fb315c57e50aa499bd0829172ea2e7a5289c20d2e834eca1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
