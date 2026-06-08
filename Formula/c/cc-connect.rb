class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "3d3d9439e225d226b15463453d585281ae5798080ed0078345c4d26c2f16a3ff"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ba89fcf03fb33ca8dd51d9e9bc95af8b6ef0f5e663ac68306ae9ee6cb04a5a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ba89fcf03fb33ca8dd51d9e9bc95af8b6ef0f5e663ac68306ae9ee6cb04a5a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ba89fcf03fb33ca8dd51d9e9bc95af8b6ef0f5e663ac68306ae9ee6cb04a5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d38159f9eeac6b6892eb503a483279a9cabd5d7cd080a5871f6b363fc7a7297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d71c122226629b4d4c013faa7f76cbbd9a8b5b3cfc81cabe43e27927fc5d0c6"
    sha256 cellar: :any,                 x86_64_linux:  "fe9375585dc1b39eb549e38628c340d54c8270e6e7d9718474bb2c22d119b0d2"
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
