class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.15.2/source.tar.gz"
  sha256 "ede9b9640392c8688f22ab0e252de3b2b047dd0824c62d31a32c7462ddcb56aa"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60d9d0bdf1ca670008a6421ec271daf2f4e5df1747379266f9ce7430545e1873"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5a83ca18e8a3d01e51f0bde588be44f6fd1d85b6bb9a6f7190fcf66a3989257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee645ee5481c656712584a8f0cf48da74ab45ad4e75782315030435be5a3cd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "06856538eb53b070b7ad08822c465682f3857c963f124c5687a7080c48f8e5c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbcedcfbfd719b435f9424cb56982dca6efb62c51120f88f6b654884aebb043e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e8fcbc5030595691354bb333b1bb0b398acde0497c0d3b19ab94891dc9864e1"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin-server")
    pkgetc.install "crates/atuin-server/server.toml"
  end

  service do
    run [opt_bin/"atuin-server", "start"]
    environment_variables ATUIN_CONFIG_DIR: etc/"atuin-server"
    keep_alive true
    log_path var/"log/atuin-server.log"
    error_log_path var/"log/atuin-server.log"
  end

  def caveats
    <<~EOS
      The configuration file is located at:
        #{pkgetc}/server.toml
    EOS
  end

  test do
    assert_match "Atuin sync server", shell_output("#{bin}/atuin-server 2>&1", 2)
  end
end
