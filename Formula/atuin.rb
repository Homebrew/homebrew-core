class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "25bba040c828ed6b36fd2c8903cc157ea8259e578d5a0bd71e8b69935d9bede4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f78a1d5c49667488f97be09ea2f02ef7ea9594ceea889f410e3a7994fab5a80d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "930a13f27ac24f47ee6ae110d5829a77caeebcc859dfdecf87f1754191812e40"
    sha256 cellar: :any_skip_relocation, monterey:       "375fdcd8b6b460eb8ace1caa5ea66687142ec2835979697453bf1a19f6c04ab7"
    sha256 cellar: :any_skip_relocation, big_sur:        "72dbb9727aaf2d467c222da1f241c0b66b678448efee1435c3a8d380a1b2ca3c"
    sha256 cellar: :any_skip_relocation, catalina:       "86c8d275b9057fda82aada359c3d3f94dffb3d7e266f5e670d17e0b04c5e6d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad208a530c030629bb4430ed938676e3aeb1dba399ac2dbbdd4547c5538df571"
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
