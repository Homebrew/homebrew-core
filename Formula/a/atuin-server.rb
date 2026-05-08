class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.16.0/source.tar.gz"
  sha256 "f29f4a6390b7d8025ff7ab4baba60c264c124ee9f307bb1e0b28355c637db860"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a68c9fa6fb2891f58ee652131d49a21544da020f6ea13595b2514e9e370994e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84d42bec3efb06e7ef3ba79fc6473811582729bbba9a178f5d82e04b9107e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5782b7576fdaa7bce5f866422e1162df013e79392a3e91a59abd915e89367ab9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f92f66d0c0eb4c2f4c9c8cc32aa1f66a29a89a53162d9aae2f1e3501bd3664f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f12423de082c66f7cdf0939e2ccf077112e286e77c3cf8aaf9d8103832063eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "635ff56506aaeafa47c4f47fcad0c27f72bbbc60ee2780973cb8b5736d8ee12d"
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
