class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.17.1/source.tar.gz"
  sha256 "db9605840e7a66a45b541b6042491b2bc80207b4440196c41bbbf0c3cd4e75d0"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bac6789d6e411ed61efbd0ccc97c14ccbde1b429c6f1c8b7f1f768b6e01e774"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72919b3cbfded726d1f094c276526ebf4363c895a743fe59d0eab23375413090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a55d74c56b6fe19a02a01f552c870e129699b404d91eaff9b83f5fd5d2b5c455"
    sha256 cellar: :any_skip_relocation, sonoma:        "650be8bd91a0570f42d957cdb2f1cab7b5892aace6f6338cb506b6dc235b3aba"
    sha256 cellar: :any,                 arm64_linux:   "b5585f541e33903585750cfc1f08641dd55e933db43b6a161850ed067a70aa2c"
    sha256 cellar: :any,                 x86_64_linux:  "837d66df18f9105a1fc6e130b2ed13b0826940ef4e19ba75e2535f5769b78023"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
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
