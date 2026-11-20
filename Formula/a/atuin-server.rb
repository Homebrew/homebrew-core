class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.25.0/source.tar.gz"
  sha256 "2d0472398a69a979089736fb34868b3b43a9a71c8f46f302667faa51176be5bc"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f076087fb7b3d8f3c90030bd95a60c78bf0f2d802edca4fc850f545b911e481a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ec8963969e60438e8e1804301fb2054ebf8f99293a029ca854a4a219d9f307d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "191d458174d973c25ca852bf8734cb4e45d489ac9305f601cc187248e057188c"
    sha256 cellar: :any,                 arm64_linux:       "4e0b3f1379b13066ac68614c9e87706d604f8872a82f364ea39afe6ca2216984"
    sha256 cellar: :any,                 x86_64_linux:      "141179b834fbf9ab9aa874d00ee4ef22c81f324b5160d53eedb7d10ceff385b6"
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
