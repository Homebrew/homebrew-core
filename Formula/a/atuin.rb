class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://github.com/atuinsh/atuin"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.4.0.tar.gz"
  sha256 "de6d2bcf10de4d757916c7e92a70f15929fc1dea75abc4df09b0baedf26a53b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186d1bb3e620de43fd544ba346900eff75967f539a6d2760af15217165d59f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89e0b3c0381ef67c3e5184387c201847c9171329305a06db2b8021f6cfa693af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1e4f797216accdd26c692f7a98bf47cfec97c368bb03ade47b8235a223162ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "9850fd5d210d698b3ced0c3fd51ef05ba9b196a738e0c07f02e738bcc193e39d"
    sha256 cellar: :any_skip_relocation, ventura:       "a6c6aff63af672c1a09f1bfd05870a11064d2f920d369fce61b94e2b1bfd38bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58b5d8e9f750dec386e4ceaf09e58e7e071d4e68312f82b0be74b1ae3894e710"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/atuin")

    generate_completions_from_executable(bin/"atuin", "gen-completion", "--shell")
  end

  service do
    run [opt_bin/"atuin", "daemon"]
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
