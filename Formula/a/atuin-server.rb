class AtuinServer < Formula
  desc "Sync server for atuin - Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh"
  url "https://github.com/atuinsh/atuin/releases/download/v18.13.3/source.tar.gz"
  sha256 "71e9fa1bcabe1f312b1063b66bd23aeff4c04e7a77d4f763351eb088c20939f5"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e62507789609b8c6a016481130583c662b47fb4fdbae74aae5a6b2d84c54e15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c6222a023bf011a3c07552cc56c97e69ce9aec0ef4e81ef61d4a30653c9fca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e60cbe139e916a97c7237dbfe242348ec7fbbb6fac1a1ac9370551b8b4759a6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "019dcaca322600d914b8794ac5e3d2bac915579c1ef7e3c9893635c924d1b1a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f8f79f53680a199e05e4ca934dd6812766aa524a469afb3e96b0939011a75d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda18d898abb57506043fc27248a9bf8769828d6c6625ff4c4b738a9d11013df"
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
