class AllSmi < Formula
  desc "GPU monitoring tool for NVIDIA/Jetson/Apple Silicon/Tenstorrent"
  homepage "https://github.com/lablup/all-smi"
  url "https://github.com/lablup/all-smi/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "611fd1efb0909fdbbb8371612988578a9fa515eb99f4b3200b2237eaf17c82aa"
  license "Apache-2.0"
  head "https://github.com/lablup/all-smi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "98b067d24093787f089a0e01da8e379f9aef1803da628d68a9dfa58cd75f109f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75087cbab7a9eccaec63519d6aa2b506fffb2f16de65aefeb1b0eaeae0ea9790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f59dc26866695f5bd45f830edf977959a9d8f13c27a7c66c2d2bd975e180467"
    sha256 cellar: :any,                 arm64_linux:       "8abf87c04b25294d4f5c606ca738f18e8e0a99fcf1d6eb0cb03e5e112f42553a"
    sha256 cellar: :any,                 x86_64_linux:      "1a72e59267865b328eecbffaa9a5d59e8988f28cb743b970f5e004f9ec33f736"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "protobuf" => :build
    depends_on "libdrm"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--target-dir", buildpath/"target", *std_cargo_args
    man1.install "docs/man/all-smi.1"

    return unless OS.linux?

    system "cargo", "build", "--release", "--locked", "--lib",
           "--target-dir", buildpath/"target", "--package", "all-smi-amd-plugin"
    (lib/"all-smi").install "target/release/liball_smi_amd.so"
  end

  service do
    run [opt_bin/"all-smi", "api"]
    keep_alive true
    log_path var/"log/all-smi.log"
    error_log_path var/"log/all-smi.log"
    process_type :background
  end

  test do
    assert_match "all-smi #{version}", shell_output("#{bin}/all-smi --version")

    system bin/"all-smi", "--config", testpath/"config.toml", "config", "init"
    assert_path_exists testpath/"config.toml"

    output = shell_output("#{bin}/all-smi --config #{testpath}/config.toml config print")
    assert_match "schema_version = 1", output
    assert_match "default_mode", output
  end
end
