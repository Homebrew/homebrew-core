class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "e3b8576d741e764b4fd6e0982b609d6dca6a980dbc66a9433b552369a9e719ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50afcd45b7597fb8a32f6b48401a7ae1349cdeba8f6f98e8f1028fe4ec92b769"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50afcd45b7597fb8a32f6b48401a7ae1349cdeba8f6f98e8f1028fe4ec92b769"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50afcd45b7597fb8a32f6b48401a7ae1349cdeba8f6f98e8f1028fe4ec92b769"
    sha256 cellar: :any_skip_relocation, sonoma:        "214d56901d3c7b2966ac715c05718aa5a767eb3a5a3be0532cedc98665a1ea7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ba1039d7a63bca705c4346e4071ce4dc775800a51ba9125a683478238314ae"
    sha256 cellar: :any,                 x86_64_linux:  "eb6dfe531980ff4e241026036d2287aa46b1603e169f6f7a5b40eb0ab3fda8dc"
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
