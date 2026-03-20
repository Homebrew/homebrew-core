class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.13.3/source.tar.gz"
  sha256 "71e9fa1bcabe1f312b1063b66bd23aeff4c04e7a77d4f763351eb088c20939f5"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34d2b6e1798a198e8896bdb132abd8c9e14b74a94c5a9f2a091123993fccb5bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ec9c03937ad7c7bd97f5f31619d380966acb45a714ba8e3a0882543d09362af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eae2caaf408fa10d84b70214e29acc8d782e846c1b7b1fafc28dc249f9ac18f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ede45c02c068bf1d8bf79958af4283a3c73f5b8af369fc7ebe9edc73ba1f5a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb0224627dd05eb4633c2381ef829f3ef53aadf153015d9cd129e11aa12ecfbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20e32e0622ad7f043db867be4f9c0c0ff5431c8b0acdd1203a3f0e95178d33b"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
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
