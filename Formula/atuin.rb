class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v12.0.0.tar.gz"
  sha256 "bfeeb14c3fd94862e2cb7c57ac2b77db78686b0afe49b5597ead9cca02dcc403"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "757a906445e52cbf62e057d5dfd16d4371a742c14e35d44c35f29e0a8c2160d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec42338dbfc7dd51133caa5b9d3f8e4dd34e814f5b0aa18d8e5acf217ae6473d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "626c82b31af3652feeba4a8a386d39f20f767bd2afc52f348ff61b6a9af7d7a2"
    sha256 cellar: :any_skip_relocation, ventura:        "7dc7969d19c3fa9d4c8856cff79a948b2c2c938a6ea9102d509262f0252003f9"
    sha256 cellar: :any_skip_relocation, monterey:       "767f62cfc1de17adf00f32ad6145f9c728cd84c62e3e825aefcf403fd589e748"
    sha256 cellar: :any_skip_relocation, big_sur:        "2da5afd2179aab706b5ff1def1d68b17763708bdc47b16926902a820f15b96f6"
    sha256 cellar: :any_skip_relocation, catalina:       "d6df7e1fe4dee17158a18eb33110d0dfcf3e579a0c319af8ad9c45e3e9d930af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca011a916fd1c28781cf67d7ef38b8c04d23643182887bd6d0b8fd0bbfc2a279"
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
