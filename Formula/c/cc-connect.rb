class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "c3a47e27464dd33fbdfa0723e26e63b03350b9e15f78fd8b59e76eb15293e3af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1399fda32fbae2a42ba0381165e7ad84342a6440845ebaa9d3a05949720dde60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1399fda32fbae2a42ba0381165e7ad84342a6440845ebaa9d3a05949720dde60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1399fda32fbae2a42ba0381165e7ad84342a6440845ebaa9d3a05949720dde60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06fa01da140240db3cf5308c48aa8c10102ae2312088e92b1d48aef1901e8aa9"
    sha256 cellar: :any,                 x86_64_linux:      "fc8e7570bc62fc6b92b69448dd9dcd27af882d5d328bb61e460e238ac6a5eeb7"
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
