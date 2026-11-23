class Llamastash < Formula
  desc "Terminal-native local LLM orchestrator and proxy"
  homepage "https://github.com/llamastash/llamastash"
  url "https://github.com/llamastash/llamastash/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "62668a7feb4ef361f4754de8bf951b32e78bbe45dec501d07640a97216c68b04"
  license "MIT"
  head "https://github.com/llamastash/llamastash.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "e50987e4a7feed4d9adef7916c79463612ba1784411b63fd8a4f46805f9207ae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a5d70fce706189f96a7dc36bbf8b0a7b5d2a973e7e1a07debe588a89e52a5beb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6037f9ff7a8a98fee33c9db2e20036d2a64fa84a762f7eafd8bf3f78260d89dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a36b93299b65fb1bb6d5462b4cde1be57ca2a76703cb5fd6e3fe3b12f2cd7c7f"
    sha256 cellar: :any,                 arm64_linux:       "7cfc49a765ba723ee00be9146745dfd4ac482cae83acc9979a4e1f564f3e2b69"
    sha256 cellar: :any,                 x86_64_linux:      "e6b055ab96f55012a0e4d6af2ea7e9209f2c07d8db4789b802f9a29d937caa20"
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
