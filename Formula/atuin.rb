class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "225e2bd85370772094434841019ea628c7f0d4cf61e7f4ba986b7eeea15942a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eac13cacbcf95997ea97ecf3b02ec39e2a222a54452847c8b872a2214b7c23c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bb7c13b4b60f58f466339e9cab219fb3f7543dbb95a49f389d0cce483baa692"
    sha256 cellar: :any_skip_relocation, monterey:       "28764dea2bf3ff3a29bbba3704dfd13ca7355a73c48011f7974afd8e6111f274"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e15bfc75289fba26956025f85da586ffeca8421357ccaeecbce7b858f323e28"
    sha256 cellar: :any_skip_relocation, catalina:       "6e5bab3b4fdd65e2525ab4dcad43c5ecc84daf5ad003a85971e47d3faffc002f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93fbc9b551418d69f06deb1ea5808f59d18e356b5c09c11db425339252e2d39a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "autoload -U add-zsh-hook", shell_output("atuin init zsh")
    assert shell_output("atuin history list").blank?
  end
end
