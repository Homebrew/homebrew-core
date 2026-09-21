class NodeRed < Formula
  desc "Low-code programming for event-driven applications"
  homepage "https://nodered.org/"
  url "https://registry.npmjs.org/node-red/-/node-red-5.0.7.tgz"
  sha256 "e701362fda8930bba62a138276f147c21fcbeb61fb9778d6d130467f6d02e753"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "06a52f1445a409f12a6d8d363916ac8df0840fc5505d278c02393ff8789c6b87"
    sha256 cellar: :any,                 arm64_tahoe:       "7982a684d31c1ecaff9a5d440ecebb5bf2abd7749775beb26dd90dafb36bc127"
    sha256 cellar: :any,                 arm64_sequoia:     "7982a684d31c1ecaff9a5d440ecebb5bf2abd7749775beb26dd90dafb36bc127"
    sha256 cellar: :any,                 arm64_sonoma:      "7982a684d31c1ecaff9a5d440ecebb5bf2abd7749775beb26dd90dafb36bc127"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52f6abbfb742c04715b7d954f19177ed5aec463a1755e85dd73050986a5e41a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e2ff3cb36dacb835ee1f7bdab600bee8bf359795eb0bd051a01ee4e8c33907ec"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  service do
    run [opt_bin/"node-red", "--userDir", var/"node-red"]
    keep_alive true
    require_root true
    working_dir var/"node-red"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/node-red --version")

    port = free_port
    pid = fork do
      system bin/"node-red", "--userDir", testpath, "--port", port
    end

    begin
      sleep 5
      output = shell_output("curl -s http://localhost:#{port}").strip
      assert_match "<title>Node-RED</title>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
