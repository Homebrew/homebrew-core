class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.8/source.tar.gz"
  sha256 "2dda9f81e1b42c4f7107aeb7dc8d957f55b43d4b104db73d05caa72a0a675c71"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f515113ffd35bcd9c523f7b459e58b57889bcff457f4adfb84b6c40ba797cec5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83ba4fc19ee86f0fb84bd3bc0ff2fe4b90a2f06724cbecb2d6dca58a529aa97e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "308df06e6411b91b8fc25d0f25b1e8f50246aaad2ad58a731809f723c972921d"
    sha256 cellar: :any,                 arm64_linux:       "a3e6a0ca04e07e0fcca16a37886683fd0df725e7eb3376008a3b2389ef296087"
    sha256 cellar: :any,                 x86_64_linux:      "ee22b934d25387f79c46f72aa933e96a49b78a434a0a1b6207ee04948129a635"
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
