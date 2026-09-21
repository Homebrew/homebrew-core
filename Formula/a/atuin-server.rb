class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.22.0/source.tar.gz"
  sha256 "46f9d940105791b09d870ca87e8952190dc69f968ea0036502a43840f83a56a0"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61888be5d4bf0394a99ad3dbdd57068b102fe2cceb7844a2291907345f3bb449"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee907a1ac2e630b75dced397986c4e4fe06c4dfe8e00dc6aa1ee9054df59b325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a105fd482e56f8dced60abdd430ae1367b082340354f75186597a48031a4ea72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fd767e28179f9986f1b83d87e8c0054d66e502133e3a651d49e87345426f8ea7"
    sha256 cellar: :any,                 arm64_linux:       "a03dd9a013169971089092c63b54096d74ccf94ae4ada14e89c6b30b3f13986c"
    sha256 cellar: :any,                 x86_64_linux:      "ab55045ff2a5cfe15bbb084348f90ddb0a9c610729d1f24dd45edfa1235b9ab3"
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
