class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.25.1/source.tar.gz"
  sha256 "ee4114ceada5d0acf000b306a1a1479ba6dd1f9fec69612f511a013ffa6fcd12"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    manifest_sha256 "d038385c1b91de493621185cad54723a1af48c64f3dc70ef348f994a80f13509"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5c3b148c44163305099b9a9bafead212dd04b1ad677146ddbfb4a0287b9b3849"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09f33fd9d0cbc98105dc4247b7c1570bc0c6d6dd11482e6b9074315e5f79e578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9771fb4255cc2563db3077b1836dd193f43a7cdd0ced373f6a69d09e95699389"
    sha256 cellar: :any,                 arm64_linux:       "868e96685972c164db4ff99a217ea30f9a04dc72b6c2ef2cb79b2e471004f5c7"
    sha256 cellar: :any,                 x86_64_linux:      "ed5a7838761a337c19a54a0fcc3f4be039be3eadf866b09c43854f45d2450595"
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
