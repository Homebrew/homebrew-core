class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v13.0.1.tar.gz"
  sha256 "c012ae65b7093954bc2d614633223f181261208ca282a409f245040f6ad976a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "344d9c78907e78da772d71301d88a74ad1ba044f7aea83bf6e0d346c7a3efd3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6947bf3d2fb7716c19a67d17402845b74e201bc4d9a06d08c8d44a44fb642ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "241fab685d35619042a623ed27a531a3130cb6af85b711b6d9477540d6e76744"
    sha256 cellar: :any_skip_relocation, ventura:        "fee00d3104646864a666ddcafced63cad827dd926a74f308c1dd0c14b3f83c3d"
    sha256 cellar: :any_skip_relocation, monterey:       "a226a276a9131cff2631156042f7d90f727358bf2c0a18225f6694f0041adec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "20bd948fbbf52e400ac27e48294bd5256f644eb3865ab0be04ddbc3c958d0f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f3c131fc8ee08ec6465930734917f563263ff9626da017ef4146e79c93670b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
