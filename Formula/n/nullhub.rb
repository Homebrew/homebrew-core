class Nullhub < Formula
  desc "Management console for the Null ecosystem"
  homepage "https://nullhub.io"
  url "https://github.com/nullclaw/nullhub/releases/download/v2026.5.29/nullhub-source-v2026.5.29.tar.gz"
  sha256 "e0751611af90b6f63c8a1020a4e951b18d3bb22b86fbf38a0267183a9325556b"
  license "MIT"

  head do
    url "https://github.com/nullclaw/nullhub.git", branch: "main"

    depends_on "node" => :build
  end

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Dversion=#{version}", *std_zig_args
  end

  service do
    run [opt_bin/"nullhub", "serve", "--no-open"]
    keep_alive true
    environment_variables PATH: std_service_path_env
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nullhub --version")

    port = free_port
    pid = spawn bin/"nullhub", "serve", "--host", "127.0.0.1", "--port", port.to_s, "--no-open"

    begin
      output = shell_output("curl --silent --fail --retry 5 --retry-connrefused http://127.0.0.1:#{port}/health")
      assert_equal '{"status":"ok"}', output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
