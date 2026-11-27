class CcConnect < Formula
  desc "Bridges local AI coding agents to messaging platforms"
  homepage "https://github.com/chenhg5/cc-connect"
  url "https://github.com/chenhg5/cc-connect/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "f2098f7d61bf90c932221950a86d60fd68f9ab6cdab64430f619700bad348f8e"
  license "MIT"

  bottle do
    manifest_sha256 "38f7706b24fd7c44fe951294e1bf918033b5667d79f92a335d4f9c3884492cf5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "823907dcdb4963f2dd5c37ba6da2720ce131aae20a10c30c21d8e36aaa017c8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "823907dcdb4963f2dd5c37ba6da2720ce131aae20a10c30c21d8e36aaa017c8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "823907dcdb4963f2dd5c37ba6da2720ce131aae20a10c30c21d8e36aaa017c8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60560d5c0595eec05c806b20d08b7c6841589111145d2bf71918755f4b8d6713"
    sha256 cellar: :any,                 x86_64_linux:      "54107d5e16639f567aad407c9ca908689800f1e969a1f0ba55184a9e35cca82f"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    cd "web" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
    system "go", "mod", "download"
  end

  def install
    cd "web" do
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

    with_test_process(bin/"cc-connect", "--config", testpath/"config.toml", [:out, :err] => output.to_s) do
      sleep 1

      assert_match "failed to create agent", output.read
    end
  end
end
