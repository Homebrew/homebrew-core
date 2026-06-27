class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "0a9b4ba7fe5cccec0abddd3b0ff140ccbb722a3f9a09a6a0c22e35dea4c8ba06"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54e4f104a657d13903ce1ce96eaa10388d780fb4d866e82b608a667ba977fd0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e89fbbe8d009f13cf2420e3dd140c3423ec9a0454659c6adb1347a78846ac264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489fbd85371c173f1d88fbd27dd75d410c240cf76ebfa9b0bf5be84b40a0971d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3c3765eaa38cebe8cf1a5ad1bd95213e99872ecc918422508dc38dc10e42114"
    sha256 cellar: :any,                 arm64_linux:   "6a92e66f5231ec7474cc6305904c064721810ae9f3fcb919afc510d8e3b3d1b8"
    sha256 cellar: :any,                 x86_64_linux:  "aaaa9299ccde281d1951115f93da02b88e7fa6d699048e3b891a6dd07056d9aa"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/ogulcancelik/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

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
