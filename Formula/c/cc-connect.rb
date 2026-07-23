class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "b882f9b3d538e0446a85a97231a4213dc06c7529f9a769476e773a288d21ef54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b0346004b0056db3fcc0c67edb99ae91b9d7b29f91b721765c69df7cd8cd77f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b0346004b0056db3fcc0c67edb99ae91b9d7b29f91b721765c69df7cd8cd77f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b0346004b0056db3fcc0c67edb99ae91b9d7b29f91b721765c69df7cd8cd77f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7edb62bd536597bad2e1260ba63c0eaf0c6acba5b3ac7a0133df3a516399f8f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11b075c95700e364b008b0d041dd1e2884067e61ebbe58b64031bda67366924b"
    sha256 cellar: :any,                 x86_64_linux:  "fce5da0ed66a1d947ce4084b84a62a4dcabe25cf2820d0671025dd9ecc1978f7"
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
