class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v17.1.0.tar.gz"
  sha256 "6a0b1542e7061e6a5bcdf3c284d3ad386e3504e040fcfa1500f530a5125b37b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d62f71e30e13567c5ed6a3db149487d5edd92ab99e82d5dafe62a45f44274c84"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3732fe398acb59319f3bb7be159224c3f7a6b1e3eebc8fbc6a3c135c9de94849"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf9728ddb5f734142d49206bcaf9ae147f3e7a0f98a4f8d70e141d08020295e"
    sha256 cellar: :any_skip_relocation, sonoma:         "a75c96a139205ea77ab2ad14c87087b74bf825f765e7fb8d85c40b80ea6a2e07"
    sha256 cellar: :any_skip_relocation, ventura:        "6d99deb98741a7858d186f3caa307b7752933d2dbbad75c615e1c8cd8cbe088a"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d61666845f1667e17426f42f057275c357a96f4a68d04a0c2af921fdc3ef86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73899566dd32eb72256264080ccb06a5939fa9b9ed787d9e573006f404eb6ad5"
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
