class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/releases/download/v18.24.6/source.tar.gz"
  sha256 "10dac85691ddab85d12ac4a5d12266166630013a36fa64e0f6b46805c38042de"
  license "MIT"
  head "https://github.com/atuinsh/atuin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddafcce5bef257cbb133eb21dd0ae14880b772ed4426d9d97ab5cff41b52cc88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e7a016c97a93962ab2608f80ae8793279f0a3a7dfbd2e74417d7cf9ef1d570c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "99e66169aa300cbcbbf7b213ec2cf4934ea9cb1ebeb96365f90cf984ae4ea26d"
    sha256 cellar: :any,                 arm64_linux:       "20e7542f068ebf6a2cc266a01ca54293c4bfa1a170b2c1d5a49cb5d9e8ad77f5"
    sha256 cellar: :any,                 x86_64_linux:      "03581238d3d0d1a0399c099ea6ce7eb05f5990527ae1e7a65abfa6d74103b51d"
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
