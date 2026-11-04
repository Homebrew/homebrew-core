class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.5/source.tar.gz"
  sha256 "83f32a21916fb8d10d903a26fc0f3f5462367f81c18377b30efcbce7d8649c09"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02dc4ea55cc59552113e1689ad59362819f3b63861b14455eb3b5c66cfdb2dd3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b2586a93f59aabf8bdd55ee5bdc10dec53dfd20cd2bfc1b0f6fa7633308b12b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "90e1a585c186906d4b4fd42d9462abbf07709e3d0976f2a06763ab7a05a551a7"
    sha256 cellar: :any,                 arm64_linux:       "0fdbbd6c080d591e633631c29c8bfd88e83ac5fb8f18758f77fc0dd1456e77fb"
    sha256 cellar: :any,                 x86_64_linux:      "1da3ccc09cfa849a5af9e55514f311a64cd14131f6ea0dcfb12791e7357f511e"
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
