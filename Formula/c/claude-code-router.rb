class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.1.5.tgz"
  sha256 "d74449979282abd9ceb11b86ed897d1c3e44d8b9430de55bfcca20769d59659d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4ea4e689159dd9a56575a4ed111460a94200f67126fa30066d52294b6038842"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b525eae98e4a472af149da21c6dc1101876ef82f1e28afba644df157fcaeab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3953e2a21d506d618cddbedf59e1feb70a7b6fae36c3d97fd7d9518f67128b6"
    sha256 cellar: :any,                 arm64_linux:       "41f74b2168a10ce34dc6551250b4576258189d739562e3e6189824a00788e741"
    sha256 cellar: :any,                 x86_64_linux:      "98bf25658d5e7e85757ae0c6813237eb3e3d01a1ddfde4eed7d209d52ce6f6f3"
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
