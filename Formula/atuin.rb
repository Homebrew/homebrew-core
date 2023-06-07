class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "ad5236aa1352b469ed108486efa448bd73ea2670432cf66de043aabfadb04b89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0716d86e32ed968093fc045ea8e225bcf3d9f043c335a9c29917127f597c646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aa536b49692fab9368733f3a0a59c97f70b8f80a9051726ee2d18cfc5db707c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54a68c365f758f330029ec455e43b3975313dd253b2bd29dabbc823a3a3517d2"
    sha256 cellar: :any_skip_relocation, ventura:        "46df121a43aa2dfd30a8873c8558efe4bfaf3d2d89040b4983ef1f36f45636d3"
    sha256 cellar: :any_skip_relocation, monterey:       "d83b6320180f926e75cd5e4eab579951dd9f4f1d7363318a80e3ce95681fb6fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "568edcb5f079a7ebd073c1ac73a9d520854291a440c868357015963f03112a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a6bd1ef7f08e99d8e2990c3d4ebcfbadebb71aec03b9df0b9e6f5a215888f59"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
