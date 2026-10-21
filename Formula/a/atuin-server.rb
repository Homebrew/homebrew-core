class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.1/source.tar.gz"
  sha256 "0647e8823460745a713d0f7744c0c01b773352a482b450e6dfc1fac7eb3a2d91"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "43e462170cb049f595b53db5915de8400942733e574f7c8d9af9fccf781e411f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e69d4d9d4384b7e29e898ad20a27a2ec1799a303a412c88ea12a3c7873acd0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7c0e45ee2694d61e60a28df903d456ad683fe1528712a3b4e6d27ce43c2d8345"
    sha256 cellar: :any,                 arm64_linux:       "f1716bf026d191d89b4205712dda49fd711fafd7f3fa1f8eb2109d57b6a3ec12"
    sha256 cellar: :any,                 x86_64_linux:      "4f1abc43e146b1a9d5f58721c47ecc5243f852fa4bb00c6d0e404aa027a0f08d"
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
