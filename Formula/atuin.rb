class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "fa745be79b3689fa1036861e8a0becebaa2fd993a252dc729a49c7ad8e7922b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47da260f88ef635474d06f5a0d3f16ecc0907a21d7e31b48ebd1dbe2b90e1728"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "354efa85ede70bdd50daab1cd0ab6e4bf392bbd4ac7f7994979973a6bffd3044"
    sha256 cellar: :any_skip_relocation, monterey:       "8f811c2269819b308146f7986af4f359a10648b3cef8cf53ca346ea5a203d1b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f719c9a3923c1ae2f8fd134f17f9fbe8d54ff05a15a1ec826c3e463506fbdd9"
    sha256 cellar: :any_skip_relocation, catalina:       "2f14a6300328bb8c650c9f12892e3fff0de57dd0309163bb82a8af51cdf72afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ef1f0355eeab87aa2c64ffe5c01c0ecde1cd5d8366117a8cca639c59ddc5cd"
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
