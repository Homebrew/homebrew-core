class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.6/source.tar.gz"
  sha256 "10dac85691ddab85d12ac4a5d12266166630013a36fa64e0f6b46805c38042de"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "365585a8541717c7faece17bb7ddb886d5647084543d94ea982ad572de07d5ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41abef1f1061f3a61d857df9e7241f44428fc7962a3957eba1a7daefe7204433"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "427352dc30c7fbe1439f8ad70dd658ad2b92d5101a88eac4c515f9bcac83f751"
    sha256 cellar: :any,                 arm64_linux:       "ba5204ea91d34c2d7fac48e70006b6289a069a2f7c286b27e3ba4e0ffffe2316"
    sha256 cellar: :any,                 x86_64_linux:      "b701623ea045533530a7d9c38e701c2e409eb484f3de4fb0192f4eccc862064a"
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
