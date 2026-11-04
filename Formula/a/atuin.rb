class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.5/source.tar.gz"
  sha256 "83f32a21916fb8d10d903a26fc0f3f5462367f81c18377b30efcbce7d8649c09"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c5edd44134b86bca4f41612df264259f93f045bec5a68c1854b26b14d47e357"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ffae225927f52a14dca43a787ee28c8a4015ec94500d2858352167876096b30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bab1e323ce2a5121eb97d1130c9282d39f0ba9511bbb33b6b89747a9d0247b5d"
    sha256 cellar: :any,                 arm64_linux:       "0a8808c5cf28af8c81c598516cfb80bf0b169e0d162cf5eb9a014062cb30a383"
    sha256 cellar: :any,                 x86_64_linux:      "207aa7f5b23034117061c8fcc166a5786f2e562df7d3f30ead989edd3997fdd2"
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
