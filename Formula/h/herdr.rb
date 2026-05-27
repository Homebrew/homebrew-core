class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "80072730e5aa95dbb7526b73fff59daae2063f52da52f5a5bc0eca19e1347729"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eac906e5a5fbd32d837e367c4afaf5cc5316ee246c8c438c5f3b71621517a5d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04bb22ef92fb6399087daefca31423f92102f2b1077e3433716500b75457ffa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c8c3d20abeac57e8122a6cd0dd94bbf95e84ff1c4fe1f8779962beba3a28e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "11654b69d263019071bf6a9402e2efd003f74ef003e8138d6c8c032cedf73a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "312dfeaadb455b64f84a5a8fd34bde5caf40f31bfc6a92320e2fc2d63d989bd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05194f62d3da8e14f3d2b804cb0bfab0d7dca52ae60d60dde025b82a88fb2ac3"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", Formula["zig@0.15"].opt_bin

    # Avoid building the unused macOS xcframework for the vendored terminal library.
    # upstream pr, https://github.com/ogulcancelik/herdr/pull/286
    inreplace "build.rs",
      '.arg(format!("-Dversion-string={version_string}"))',
      <<~RUST
        .arg(format!("-Dversion-string={version_string}"))
        .arg("-Demit-xcframework=false")
      RUST

    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herdr --version")

    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s

    pid = spawn bin/"herdr", "server"
    status = ""
    10.times do
      status = shell_output("#{bin}/herdr status server")
      break if status.include?("status: running")

      sleep 1
    end
    assert_match "status: running", status
    assert_match "version: #{version}", status

    output = shell_output("#{bin}/herdr workspace create --label brew-test --no-focus")
    workspace = JSON.parse(output).dig("result", "workspace")
    assert_equal "brew-test", workspace["label"]

    output = shell_output("#{bin}/herdr workspace list")
    workspaces = JSON.parse(output).dig("result", "workspaces")
    assert_includes workspaces.map { |entry| entry["workspace_id"] }, workspace["workspace_id"]
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
