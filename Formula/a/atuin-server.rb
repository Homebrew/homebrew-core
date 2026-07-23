class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.17.1/source.tar.gz"
  sha256 "db9605840e7a66a45b541b6042491b2bc80207b4440196c41bbbf0c3cd4e75d0"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcc30d240a3c95ab0261ebbf622d56725af07e82f88fa1406cedbdfea6c1ae2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1ec94da7b741f21bb2b3e6717e5181a7abff4781e43c667ef38f6f5bb182aae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e6135dcc543b61575266c6d5ee5b26f665110bc6d5310faeb1ed0d0f9febc48"
    sha256 cellar: :any_skip_relocation, sonoma:        "77508c81e8626ae97c6996f41bf178241a33b2cc1ec80e863ccf6c1a882799a8"
    sha256 cellar: :any,                 arm64_linux:   "30e548b3017ebc963554db21b115a528d428030561f143f35e2e65c2223b67d0"
    sha256 cellar: :any,                 x86_64_linux:  "b6a4d48758806d0eaa962e0d28fa22ea001a184472dfc973bc4d969390c6ec15"
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
