class Llamastash < Formula
  desc "Terminal-native local LLM orchestrator and proxy"
  homepage "https://github.com/llamastash/llamastash"
  url "https://github.com/llamastash/llamastash/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "af28a44b2356d93e834da3eb189f79bb375b35e60bf6f684fe657547b01dd08e"
  license "MIT"
  head "https://github.com/llamastash/llamastash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e527e5367e39ebe7fa3ab5ba391fccc5c9ec58f98ff7a9417e88bc1b4a323835"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bad7753c48fb6162b2ec8bd32a30879e9fc75e871da42fd820d56202a4bf8ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5eb788ec18484323aa60d58bceac2519fe90160664469afd0b61f02b4173bf51"
    sha256 cellar: :any,                 arm64_linux:       "eba71178bf5ed50c660dff62c5fd3a789904499374b02500b99e5d3a80baf330"
    sha256 cellar: :any,                 x86_64_linux:      "9dd26f71d6e4f27888d259624172c0ec8e1b89a70189a7f38a84721e6dc13c18"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "llama.cpp"

  on_linux do
    depends_on "wayland"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"llamastash", "completions")
  end

  service do
    run [opt_bin/"llamastash", "--llama-server", formula_opt_bin("llama.cpp")/"llama-server",
         "daemon", "start", "--foreground"]
    keep_alive true
    log_path var/"log/llamastash.log"
    error_log_path var/"log/llamastash.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llamastash --version")

    output = JSON.parse(shell_output("#{bin}/llamastash knobs --backend llamacpp --json"))
    assert_equal "llamacpp", output.fetch("backends").first.fetch("backend")
    split_mode = output.fetch("backends").first.fetch("knobs").find { |knob| knob["id"] == "split-mode" }
    assert_equal %w[none layer row tensor], split_mode.fetch("choices")
  end
end
