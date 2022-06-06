class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a1da22c31053e27c7d602ff0dd70fba2fa585d580c96b22dccccdc42fda643ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8af505de9d011ebcd485f32a6188fc0db5dcbf385d1b9e94f719dbbaaa85486"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3496c265c8730b229f1599af320c0b9413390995f98fcd2f189e5a4ec26026bc"
    sha256 cellar: :any_skip_relocation, monterey:       "ecd4a164fe339c7225eeb716caf5983467ba44898aec9401385907096b01a56f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed95f03aafae5dfe3dd9d2f33370ac777a90f6e4b248b4c4aaa3b675533603c8"
    sha256 cellar: :any_skip_relocation, catalina:       "e46f7c12dfa5799d4740e3e86e7342814ce0042a2dd989a9da2b36a66c001f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8628dd2df094e43efbb419f7bc2772d215f40cef879d5391833bf23ca32e1dfc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("atuin init zsh")
    assert shell_output("atuin history list").blank?
  end
end
