class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/ogulcancelik/herdr/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "86f4ade98e4fa048b99ad59d1453da00b691dcdf559bbd18441f495b448c02fc"
  license "AGPL-3.0-or-later"
  head "https://github.com/ogulcancelik/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f85448213ffdd266a1a930520de46298f397a85f5237112eb3e2b79e87299a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68840c585440c0641bee930e248fa1dba7696f1953a10aba05e807a094f10eeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "214bcc9f53189fb5d023252f460ea7aa1a8d9576e4dc94563328ef807aa8b669"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8fcb2168d54628a1f10fe29a32b9d923f24f799ee652f8e5c51cc854bb5011f"
    sha256 cellar: :any,                 arm64_linux:   "ac35188b3b0c42db8f2b021bfee9113d466884e508a3c20a25c633681b70be04"
    sha256 cellar: :any,                 x86_64_linux:  "e9d56e466c9175423c8e8ab64ca298cb8663bd61049e87093c5169bcb47ac0ea"
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
