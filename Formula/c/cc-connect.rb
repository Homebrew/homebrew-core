class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "3edbccd5c66848f14239f9778cdd7e0941f0d5d3b276bb424472e2c975dcb5fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85ee53685016266995812330136390666bb8bbcd16c0ff4e5b9a710609f14810"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85ee53685016266995812330136390666bb8bbcd16c0ff4e5b9a710609f14810"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85ee53685016266995812330136390666bb8bbcd16c0ff4e5b9a710609f14810"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dd6ff31da1cf9a46e3341a7062b51512bd4684937f118933073843d7908f2d1b"
    sha256 cellar: :any,                 x86_64_linux:      "2f6867669b756e725971fa4d18a3d41a4c049dcaf0518157cc71bab1b2acbd2c"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/cc-connect"

    pkgetc.install "config.example.toml" => "config.toml"
  end

  service do
    run [opt_bin/"cc-connect", "--config", etc/"cc-connect/config.toml"]
    working_dir var/"cc-connect"
    keep_alive true
    environment_variables CC_LOG_FILE: var/"log/cc-connect.log", PATH: std_service_path_env
  end

  test do
    assert_match "cc-connect #{version}", shell_output("#{bin}/cc-connect --version")

    (testpath/"config.toml").write <<~TOML
      [[projects]]
      name = "brew-project"

      [projects.agent]
      type = "claudecode"

      [projects.agent.options]
      work_dir = "#{testpath}"
      mode = "default"

      [[projects.platforms]]
      type = "discord"

      [projects.platforms.options]
      token = "MTk4NjIyNDgzNDcOTY3NDUxMg.G8vKqh.xxx..."
    TOML

    output = testpath/"output.txt"

    pid = spawn bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s
    sleep 1

    assert_match "failed to create agent", output.read
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
