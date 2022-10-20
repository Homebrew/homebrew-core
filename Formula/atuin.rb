class Atuin < Formula
  desc "Improved shell history for zsh and bash"
  homepage "https://github.com/ellie/atuin"
  url "https://github.com/ellie/atuin/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "29689906e3fd6bc680c60c3b2f41f756da5bd677a4f4aea3d26eff87f5bebac4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba812d694dc53908df49b941a5e57984df1c1afaa99ac3c804fc7816eb2f38c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbd9725c2ae18c6eb3f71683d9ec28b8dbfcb939696b710cd36f2f96da64c84f"
    sha256 cellar: :any_skip_relocation, monterey:       "36ac291864bd8b1e06ce509b65ac5384a5ab278ec8abee54283c3fbcf04f8547"
    sha256 cellar: :any_skip_relocation, big_sur:        "a71b2b07d5d0b88fbf1dfd4a4b9eeddf32dd8dfb9e0c0163607b61f315b03f0d"
    sha256 cellar: :any_skip_relocation, catalina:       "1e0cef06923310d2b1a4a8d0cb099dd09535aa18258acda7afe33c07e9f3f6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c955a8e1972c61ff9cab19da699057c13dec9e54407a3d2fb0bcbd0cd59d004"
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
