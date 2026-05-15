class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "3d3d9439e225d226b15463453d585281ae5798080ed0078345c4d26c2f16a3ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdb63aa32fe0d2f9fe92ca5ab18e295eea93d048bc5195444d149e924f9644a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdb63aa32fe0d2f9fe92ca5ab18e295eea93d048bc5195444d149e924f9644a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdb63aa32fe0d2f9fe92ca5ab18e295eea93d048bc5195444d149e924f9644a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7726254e96a7a3c969b0f5c560bfd676e954cbad5d895949f62dd10670abd2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10a90420e60e3bd1c1971bbb49017eb7b5ce804df491eeb45435c94f2f53e2b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "933a873a618580499db5806ac08d5ece3865f26632e872b91fc60a26cfc99ba0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildTime=#{time.iso8601}
    ]

    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    system "go", "build", *std_go_args(ldflags:), "./cmd/cc-connect"

    pkgetc.install "config.example.toml" => "config.toml"
    (var/"cc-connect").mkpath
  end

  service do
    run [opt_bin/"cc-connect", "--config", etc/"cc-connect/config.toml"]
    working_dir var/"cc-connect"
    keep_alive true
    environment_variables CC_LOG_FILE: var/"log/cc-connect.log", PATH: std_service_path_env
  end

  test do
    assert_match "cc-connect #{version}", shell_output("#{bin}/cc-connect --version")

    (testpath/"config.toml").write <<~EOS
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
    EOS

    output = testpath/"output.txt"

    pid = spawn bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s
    sleep 1

    assert_match "failed to create agent", output.read
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
