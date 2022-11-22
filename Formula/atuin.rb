class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "bfeeb14c3fd94862e2cb7c57ac2b77db78686b0afe49b5597ead9cca02dcc403"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7fff6ab64237cfd0296d657146c0ccac42f62ae25d135bebb5f0fbd2b841763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ce3c57d76020baaaee7672c31aeab51ae753dfb2c42242ef1ca9bffc33df14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76b5bbebe4c2758f9c44cc86030279399d501c0a0ddee820900738cf45db3b65"
    sha256 cellar: :any_skip_relocation, ventura:        "f633e62d06144cf42194fa59c960fc05de0401652f042c5892d787fc9a8be967"
    sha256 cellar: :any_skip_relocation, monterey:       "56a9895ff2a37d67490851811422b180312975732e2f34e778249c2e4bfcbd9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "741867bcf7ed64988d3084a1583b5186a62f542d13bedde156feb31af338579c"
    sha256 cellar: :any_skip_relocation, catalina:       "44805dd61ee6163c3ae4ee537a00168f28b0b616181e202a2808867b8d0e4d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bba7de6d1c3dd8a1e7ca6041f135056bccf8a268bd23ba6c3e215351ff87206b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("atuin init zsh")
    assert shell_output("atuin history list").blank?
  end
end
