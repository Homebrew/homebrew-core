class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.12.1/source.tar.gz"
  sha256 "94b38e6031bad2409c176beae63580da35a1c3a1c129cc7c4c8f74f1e2965638"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59dcbee9c296a929e826aa0f45b4e8a2c40e5d0e78058324655b904b9c5a0d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324426bb22f49bd16d0ea51070c12e713ad116f07703917646fde4bb74e9527a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0e51401941cf7ca558952da210e3f3d26b9e6546c3e2a306b9cc50d45230a05"
    sha256 cellar: :any_skip_relocation, sonoma:        "14162bb60283a0e9bf4f26a6dabbdaa753f40f42086c2ee4f17785b2e8285668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b720459ffc2532834e4951f3ba3d6d9ec45135b0e11a6cff0459921dd29a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0b80611a6d78c64e0b7c66ba87f411c9006bc1b071cbee8cd35a0bd692aa0ed"
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
