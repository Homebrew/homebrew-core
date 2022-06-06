class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a1da22c31053e27c7d602ff0dd70fba2fa585d580c96b22dccccdc42fda643ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc9986f7049d96cb3301845666850d832870210d89beb01735a3728b6ad96b7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0537e531ef854bd1bdf587ccea8c7552b5b5e31a8bfb344e1f3b5292efb9112e"
    sha256 cellar: :any_skip_relocation, monterey:       "95cc3cee4948b4d76582e083fc8c98290bc25aafe86d08ce7dc545996d6a0306"
    sha256 cellar: :any_skip_relocation, big_sur:        "c89592742f685d652fd703ef63eb720aa60f2e7c3220d581c5b81ad9911f1762"
    sha256 cellar: :any_skip_relocation, catalina:       "63d1be70bbf7303672c919e7f0a9364f8f546020f6c5ca455a2f8fc4c158e21e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5abc405f60e93dee90ac105ef9a790b46c17c5db7809a39aa875dcc772c791d3"
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
