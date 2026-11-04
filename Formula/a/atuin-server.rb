class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.5/source.tar.gz"
  sha256 "83f32a21916fb8d10d903a26fc0f3f5462367f81c18377b30efcbce7d8649c09"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d26b60649daa6cdadcc3a483687de7fc4762a4f02a321892dc3803da4e84c7d5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18772b6ab6124a30d46526d855fc831dcface48cc1d9e022e1e9688857edc91f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b4556ff09f6eba7b7a177a562f44ad21dddddbae02a942957eeae956adbd94d"
    sha256 cellar: :any,                 arm64_linux:       "a8232c6cc895a99286bd9a64e1442c78160267e3709b990ef2fcb59215c34e1f"
    sha256 cellar: :any,                 x86_64_linux:      "c693fce8528a4b6f511263fc0f7397976952923ce0ab6ddd9c75857f3474c280"
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
