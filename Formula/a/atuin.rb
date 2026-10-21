class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.1/source.tar.gz"
  sha256 "0647e8823460745a713d0f7744c0c01b773352a482b450e6dfc1fac7eb3a2d91"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b40c9064e22dcfc450d3d312d9014d04c16d8fdaedbb9719acf1be84e764913"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f99f16f70862cd7b04b4af33621c40a8016790c72b84f9f45cac6785a49a2fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3edc226cda7e41b6b871ef57a452d2d978b8c38c66f72c8d5bf1c42b916cc6e1"
    sha256 cellar: :any,                 arm64_linux:       "b4e38d67bba20842b7182ba836417c73c9a5e4d1dd44439e3c13e267c10b0865"
    sha256 cellar: :any,                 x86_64_linux:      "b1295a2f3bfd969213a13fe4caf7742bb31f46beafbe1c03f7b8e8b7fc1fc034"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
