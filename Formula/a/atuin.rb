class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.25.1/source.tar.gz"
  sha256 "ee4114ceada5d0acf000b306a1a1479ba6dd1f9fec69612f511a013ffa6fcd12"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    manifest_sha256 "28caff7ba8bd75cd48475dc5d811ac3acfbc1e2fe86fbfb746938cfc7b6956df"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9aca8634df20ac4c71be79eb584b407b71aadb1f5727713a01b05f2ce0211bf8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6638103998791995d4ade6d12e9af2de113d487590df67de0a88e6ae18ecd363"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bbb80517936fde6a4608fb8ff7629e63bc21644ccab5b1ac013fcb41c269f2d"
    sha256 cellar: :any,                 arm64_linux:       "f119d47fd36975cd037e8998e1facceb7031a9e915dfa8d2871ec8b97dd6c0c7"
    sha256 cellar: :any,                 x86_64_linux:      "e82568a44892aa8135cb77a2e09568f0bd3051a9d1e999ce6ad6e105526cffc0"
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
