class Llamastash < Formula
  desc "Terminal-native local LLM orchestrator and proxy"
  homepage "https://github.com/llamastash/llamastash"
  url "https://github.com/llamastash/llamastash/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "924d1229a3824aa877112d946ab2cec94ad62c5acc5de0b7d5eb46961186f7e8"
  license "MIT"
  head "https://github.com/llamastash/llamastash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e83185900fe8a5f0c6c3c801f1f488549fa5c42db696a9a5d875fa414d2fffc0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "233a8d20ea9960fd287f4bf5ea1077b80871fc5e0fff972368c23348b75fc374"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a265f837f0cc305c0522ac840dde1059a216acab079646dff2c723af5eb0d13f"
    sha256 cellar: :any,                 arm64_linux:       "ba1c53ebb4d2365cf5642fb03283c236082dfee17c460d26e828eb8adf63a8dd"
    sha256 cellar: :any,                 x86_64_linux:      "198660258c9a3fccaaa885c175acc3fecbfd1a407024bee4d55fb0a302bfca8b"
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
