class Atuin < Formula
  desc "Improved shell history for zsh, bash, fish and nushell"
  homepage "https://atuin.sh/"
  url "https://github.com/atuinsh/atuin/archive/refs/tags/v18.5.0.tar.gz"
  sha256 "f3744e8dfee2c7089ac140cb8aafe01e5d77a2299097a2cc0a42db26d127340a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a8c1e89b23c3300ea6319e8c6c41553a0b1f5387351b43ac3a64360ad05fc7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94caf9dd590adf5f35ecb4690e60b6ddee3fbf5eca62b963731d8299ad5c0986"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bd749df3479f8ab72b0b306b746f04fd9574ef6850e250282e73f3f6f52b92d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfbbbbaf4daf6423f5e79d8e0063eab95522b3531c3bc650a9872c40908e1425"
    sha256 cellar: :any_skip_relocation, ventura:       "d3f64a0548bf35660cea247be7aa64aa878d3f434d0f50f8a6ca37d82978fa2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1ff3cf9ad4fd437c36e857003ea926436ee859b4ba8d3cf02ac8f0ef61c0934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4314a07c3072b17a499c6cda962bd27bf74caac45bddadc07b57666d79b1eae4"
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
