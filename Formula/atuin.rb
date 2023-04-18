class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v14.0.1.tar.gz"
  sha256 "00ba6eea19f11b3f73652e71af69b3dc7eb221761519f3b9680047f5476915b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b01fb73284901416cba24a774288353204e0f57a3303cf337053a9b49f491953"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77976415980d1b5548e3949cd7d192872c9f3956b004d07a7a1a8834517d441b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cf663591c9e377db48ae3f4408002c540d9443c722264ab154ece75a5f84e98"
    sha256 cellar: :any_skip_relocation, ventura:        "7b96277544d456f33e4e198f1d3e7a5ed4efeb8f65891df568fa3e5d9fa7b0f8"
    sha256 cellar: :any_skip_relocation, monterey:       "04e5acd4c73e0eaee2ca1f9557a6e7b0343ae99fa34f52a836316c682c387ab6"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa5365dbbbca4f684391a248aebd937e54236b7d31448ad53eeacbfcaa83fd6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29ba2253707e0599a96a2e8d5d77b44a6d075a8948c9ee4a45dcf5837e2a463e"
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
