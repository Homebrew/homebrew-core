class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "23904ca3c3d73dcc84316a039c30ff87448fcbb33f4170633ffd32cf3eea599d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27cdce6fc16b6bc75a22a7b2158ce3d7ff0747c885fa4fe5d4e5de02bf19db18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27cdce6fc16b6bc75a22a7b2158ce3d7ff0747c885fa4fe5d4e5de02bf19db18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27cdce6fc16b6bc75a22a7b2158ce3d7ff0747c885fa4fe5d4e5de02bf19db18"
    sha256 cellar: :any_skip_relocation, sonoma:        "d13532caf2cb94ea70f453d1704c871841080d1fdf63e484541e7e651431f2f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e29b824eb1cc5f57fcffed836a5d0b41c3da53ef646571f19789f67f9bec4fdf"
    sha256 cellar: :any,                 x86_64_linux:  "b89d982451e283ed2437f93c6b11aeaee9a571dca65c3de622ad147013705297"
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
