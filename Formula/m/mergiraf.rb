class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.4.0.tar.gz"
  sha256 "354f1d90c192f85598d51f10fa2a3b793d89edabc2a55f2a0cecbd16efd87db8"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee97d6da55666b61d293577087ab0c1a4b689f6317346c09e3df57e16cc6b358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45a86129a38de61dfca828ab1c2638125b04b848de257e4b2ea6be0a9c33c9f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca70e4007db48e9accbb4b0cfd1a709d2bfacc6fe1f9eb13d1e1920b93cfd5e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "81920d360ba38e532764588f5199fcd8aac8fc778d5d4537f7460a973c631f5b"
    sha256 cellar: :any_skip_relocation, ventura:       "3a57d449bfce17017e2fa9f5eff0e416dc7e8a11c566b539915be3e85cb6e341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b5d8e9d28ebed44c0b6d15321af785aadf2aae95cb30bf3a0d9fce5cd3ec66c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
