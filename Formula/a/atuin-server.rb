class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.13.6/source.tar.gz"
  sha256 "89d12e2b5b69a0cf47113a0e9c55edd297ca5393be11e616685d0b6567133acd"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca6dd7874a43c17cc64711ba68b2b0649d0873840b5711e79f3adf314b646fd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2299bbe1c03a8dc4ae77db02af4cf2880f6195a56fda622f67239a6465dfae94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b262dd7afc9d94da370005a11fa58a1f1a5d921025330b8a737377aa908deb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f25d595de97ad47bf935fb896445a38d5851d7fada06047e508ec1845487da73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8672b8eea644273ec78e061c5fc32c26a71490f3044045f69b81ee56078bb5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c20f774a6969f568d8165cce3c3a8d9005a19db0234d71ceabae70b042f0814"
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
