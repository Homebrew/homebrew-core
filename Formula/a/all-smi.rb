class AllSmi < Formula
  desc "GPU monitoring tool for NVIDIA/Jetson/Apple Silicon/Tenstorrent"
  homepage "https://github.com/lablup/all-smi"
  url "https://github.com/lablup/all-smi/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "1feeb5f4d10489858220ce051b5685338063f0ad0b2588d8375bbc51516c62d8"
  license "Apache-2.0"
  head "https://github.com/lablup/all-smi.git", branch: "main"

  depends_on "rust" => :build

  on_linux do
    # build.rs runs tonic-prost-build over proto/tpu_metric_service.proto, and
    # that branch is `#[cfg(target_os = "linux")]`. prost no longer vendors
    # protoc, so it has to come from the protobuf formula.
    depends_on "protobuf" => :build
    # libamdgpu_top defaults to its `libdrm_link` feature, which links libdrm
    # rather than dlopening it. Only the AMD plugin below pulls this in.
    depends_on "libdrm"
  end

  def install
    # --bin is load-bearing: src/bin/debug-pid-mapping.rs carries no [[bin]]
    # stanza, so Cargo auto-discovers it and a bare `cargo install` would put a
    # stray `debug-pid-mapping` on PATH. (all-smi-mock-server stays out on its
    # own, behind the non-default `mock` feature.)
    # One shared target directory so the Linux plugin build below reuses the
    # dependency graph instead of compiling it a second time.
    system "cargo", "install", "--bin", "all-smi",
           "--target-dir", buildpath/"target", *std_cargo_args
    man1.install "docs/man/all-smi.1"

    # The Linux AMD backend ships as a runtime-loaded cdylib in its own
    # workspace member, which is what keeps libdrm off the main binary. all-smi
    # dlopens it from lib/all-smi and degrades to no AMD detection when it is
    # absent, so this stays a Linux-only extra rather than a hard requirement.
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
    output = shell_output("#{bin}/all-smi --version")
    if head?
      # A HEAD build reports the crate version, while `version` is HEAD-<sha>.
      assert_match(/^all-smi \d+(?:\.\d+)+$/, output.strip)
    else
      assert_match "all-smi #{version}", output
    end

    # config init/print round-trips the TOML loader without touching hardware,
    # which keeps the test meaningful on a builder with no GPU attached.
    system bin/"all-smi", "--config", testpath/"config.toml", "config", "init"
    assert_path_exists testpath/"config.toml"

    output = shell_output("#{bin}/all-smi --config #{testpath}/config.toml config print")
    assert_match "schema_version = 1", output
    assert_match "default_mode", output
  end
end
