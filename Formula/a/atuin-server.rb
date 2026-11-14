class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.8/source.tar.gz"
  sha256 "2dda9f81e1b42c4f7107aeb7dc8d957f55b43d4b104db73d05caa72a0a675c71"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7547944d68bf83c4ca87408e2b69643a4c0ab39db4ecff7620c285e5b83b135a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "922f88ba3eff6397377e7ff8595384b6498006f6c1afcf5ef1f72e6adbbad8f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efd488dfec7d68d21eca8532a2422ac8ad43fcc5118d211c60e805add3850387"
    sha256 cellar: :any,                 arm64_linux:       "f1fd54d57fdf558b8d2ccf3709088d4f75ad26deb5495dd360e1b53475d743aa"
    sha256 cellar: :any,                 x86_64_linux:      "bca7bf50593b86784b4edd4711d3d74966821e82e119c2d69bbd0a250cb3dd7a"
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
