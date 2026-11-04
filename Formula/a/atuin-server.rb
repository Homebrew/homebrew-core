class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.5/source.tar.gz"
  sha256 "83f32a21916fb8d10d903a26fc0f3f5462367f81c18377b30efcbce7d8649c09"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e44761ec41f6d1623b17a97db11a9d5fcdc82734d1e242a15bfae29d3e1f8731"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a23a26ce972d6534f79c539516f537753109213dd4a10e7ce8cf28a059d1759e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64958cbca57fa83734203ee8e5d4965740529e65d24f6c709c8047694c9250de"
    sha256 cellar: :any,                 arm64_linux:       "5061b4e787a61d410aa9c723ad703008da099d70c018a705d4160a2076328f12"
    sha256 cellar: :any,                 x86_64_linux:      "5e16a8c666377f960b63fffca8c79c0176790c0f6e16cd337a66afea2acb42c4"
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
