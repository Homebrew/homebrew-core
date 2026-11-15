class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.1.3.tgz"
  sha256 "34aca07d5bf6bc654c7a6ea98f44e90823288c303bb3b0d5da40a0d1b1e606f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3cc32e607f35f501f28eed529c5eda6425ac0a5b890b7737d66e4547d39366f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a47b263fa41a619805f218cea8e93ebb7b855fff3e862c3dfe6f44faf6bdb54"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f8fb371dc4172754125f801f1a0bbe0e5a4bea639578769c3f114ddd5656a1e"
    sha256 cellar: :any,                 arm64_linux:       "7d2fd9973ad6332d35c4025fce77dff893df75091602e6b755754b0339a3425b"
    sha256 cellar: :any,                 x86_64_linux:      "b57abfdf3bbb3924358719da5d35ce4ca8f232819a2a5f20fbf57203a8807802"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # better-sqlite3's prebuilt binary is skipped by the sandbox, so build it via node-gyp.
    cd libexec/"lib/node_modules/@musistudio/claude-code-router/node_modules/better-sqlite3" do
      system "npm", "run", "build-release"
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".claude-code-router/config.json").write <<~JSON
      {
        "Providers": [
          {
            "name": "test",
            "api_base_url": "https://api.test.local/v1/chat/completions",
            "api_key": "sk-test",
            "models": ["test-model"]
          }
        ],
        "Router": { "default": "test,test-model" }
      }
    JSON

    output_log = testpath/"output.log"
    spawn bin/"ccr", "start", "--port", free_port.to_s, "--no-gateway", [:out, :err] => output_log.to_s

    30.times do
      break if output_log.exist? && output_log.read.include?("CCR service started")

      sleep 1
    end

    assert_match "CCR service stopped", shell_output("#{bin}/ccr stop")
  end
end
