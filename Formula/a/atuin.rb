class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.16.0/source.tar.gz"
  sha256 "f29f4a6390b7d8025ff7ab4baba60c264c124ee9f307bb1e0b28355c637db860"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "713466c194f5e9801aca93c12b1ec3f19969c900d20ea04b9846f44c8b179476"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c2c960d8ce150aee414136aac9f9011cd953b99f174cc663eb3c40f67b15606"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a25c63dc5d6dbe2ddbcc4f4029b197eb63e33b02b50ab0b8ccb2cb3e03ca91"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ab8b69207cc14e46804e894aecc683f725905d76f056de4d12f180cf58fa2ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096f5b22e04317752e8318f07960be6f9c32ac2701a2990b1a8804d06dce510e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c1f53b1350fd47d5bae447f059857dc24b757a71ac25c098009d74ed344216"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
