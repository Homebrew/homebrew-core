class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.19.0/source.tar.gz"
  sha256 "02fc084a925824f9b8ad899803da4c895341a6ae2fcb585ca8eac4fbe1fb454e"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37e39d03014b6bcb952d9c22121d8b62546dfed9eecd8858a248d782a72cc81d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dc2a797a5da8e4cad6725d743d80aea25274165b2f310fa298abea502519c5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "080ba1313378855f680dc9ca1350f0f712902712d7a9511e5e72295b6b3e4a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "49ac5e1e8c58a36156612cc6b39e631775902c24089861f55b271a6a9f994ef4"
    sha256 cellar: :any,                 arm64_linux:   "2e8111dea9ee8aa82275a137297e9747607c51976ff0671ee04b151e475aaf60"
    sha256 cellar: :any,                 x86_64_linux:  "f13f1e4872e638dbdc0540f637c75a42580f79d97b5798e6c0b780f76875ea82"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
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
