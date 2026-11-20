class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.25.1/source.tar.gz"
  sha256 "ee4114ceada5d0acf000b306a1a1479ba6dd1f9fec69612f511a013ffa6fcd12"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7e3ac5bb622a95b5a73383d60626eee5ffb914ba720dafc112cbb4af88e4324"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fde3f6585186952dc5d9297b34ab67c0553607d8c51ebadff06d3614f8ea4fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5308df3c43afaed9fa8986cc56c3c85039dc8ce31ad13c7e267aa5aa4e9b673a"
    sha256 cellar: :any,                 arm64_linux:       "6433d57c62e83a96133c61f454e597e1d35f7ae4001e74be13e56e75aaea7089"
    sha256 cellar: :any,                 x86_64_linux:      "666067f5cebde4051092cddeec9b642572a9f2e966b7ab01814e962e0ee0a881"
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
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell",
                                                      shells: [:bash, :zsh, :fish, :pwsh])
  end

  service do
    run [opt_bin/"atuin", "daemon", "start"]
    keep_alive true
    log_path var/"log/atuin.log"
    error_log_path var/"log/atuin.log"
  end

  test do
    # or `atuin init zsh` to setup the `ATUIN_SESSION`
    ENV["ATUIN_SESSION"] = "random"
    assert_match "autoload -U add-zsh-hook", shell_output("#{bin}/atuin init zsh")
    assert shell_output("#{bin}/atuin history list").blank?
  end
end
