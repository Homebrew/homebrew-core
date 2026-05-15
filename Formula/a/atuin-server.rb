class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.16.1/source.tar.gz"
  sha256 "aec5c91207f080becc4b13593d5b7edc46685e8d4dbfbaef33d31f8058191bc6"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcb44d10d69271755ec4faef6db6042125805fb19e01d8a2600dcdc0add24808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0e3f52b33753dab6f44671e1546ad8047de856173cfc85e48bb4a19f8f39ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "900ce2f8d2d41e9d1abe41e9d128b1963f17bd1079c7aac60ee280e61c70ec02"
    sha256 cellar: :any_skip_relocation, sonoma:        "904496cb6e5c3dae118687258499944bdff7f6bc69d2d86db961687737f8544e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88b1b28d402d70abc6b90cf8eaca62729245211e19c2ed57c1dfcd519be021c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc546dc50022138af0b53389e3de0bbe482aecfe2cbbeb7e019d707af2a08d7f"
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
