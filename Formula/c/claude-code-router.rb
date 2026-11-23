class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.1.6.tgz"
  sha256 "5fcf5ce431d450aee7fad5296da8007b517668b92f1a1dcaf7c4d28f08e2ec52"
  license "MIT"

  bottle do
    manifest_sha256 "5f66e007faa92546a423bc0c35a58987ed34aa2ff49664a175f458daee928646"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2e86490befb575bb909bc440cf6ca416d234f35b980bf283010b37223c20759"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "353fcddafc6e4711ef6f4eec0f248c7f3d0a1c85ab212a5d8e91f8ee9059d94d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a830d117cf1e473e02b8355dc1ce8a187737d215f8828bc86e9084c73f7fe14"
    sha256 cellar: :any,                 arm64_linux:       "f078cb6d163918c981e027a5580dc16629f8b6f30ca120275b76b8c5ea1e350e"
    sha256 cellar: :any,                 x86_64_linux:      "bece6676b301a9f7ed217a663f4386d111df50175758549ad6850a40741fd14c"
  end

  depends_on "node"

  allow_network_access! [:build, :test]

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
