class AllSmi < Formula
  desc "GPU monitoring tool for NVIDIA/Jetson/Apple Silicon/Tenstorrent"
  homepage "https://github.com/lablup/all-smi"
  url "https://github.com/lablup/all-smi/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "37ddbd92f52ecfcc756de7fcf2d2f046c361c3caa5c1c67a77f797ee9f989996"
  license "Apache-2.0"
  head "https://github.com/lablup/all-smi.git", branch: "main"

  bottle do
    manifest_sha256 "a11e1413751b1bd3ef5aa8689fa86ba248d0e64dc0253b5948c9cf79ac820a94"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d669a5ce76d8749f28ef334a23e4a5033016f8824f34a7f7cbe03d9796babc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc45957eeff9d62714713d9129db92bebed63db8af3c07b411ae884b2755701a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b3994ee8f4982a4068c07a0b279460a687cb42d0c3e1c2e15df19c58bc22e139"
    sha256 cellar: :any,                 arm64_linux:       "56cd725469d89dd5b6ee24bf9ce70424e8a809cbadb60e3a19e0a0529351cddb"
    sha256 cellar: :any,                 x86_64_linux:      "fdb48102b5e4182fb53d5fb63fe0ad0d2d77fa8f6c2a8221db03510a243b2a89"
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
