class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.17.0/source.tar.gz"
  sha256 "38f78bffd059fb1ce92d9387af2084ba724a4447865c864b89f39df19024fa8d"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09bd14d7e79053108736bd4fd528e592beeca753efa0e51db19bebb4d12730dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f13aaa2eb4af1b56e4fd4812c02dd5bc74a97181b53bf33189b0889bf754339e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "702e5b131c1dc5eadd03d79c14451248941d792da9c134ecb6fb44b9a731dc6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95b31573e1f16e3480e1a26419eaf8b4edd8c05177d7a775809d15c089ade07f"
    sha256 cellar: :any,                 arm64_linux:   "afca29c139f9c7cce9c2763709931d92b8d70493e9d6f81e48964e345615b136"
    sha256 cellar: :any,                 x86_64_linux:  "2fd8da6d9dcb42648a2e9fa2464c358384e52caad2d073a89e3b11bf6a277847"
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
