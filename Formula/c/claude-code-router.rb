class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.7.tgz"
  sha256 "2f9a11854eeffa8d626650942f0e8c5a06e274091c95a133966d9cf0ef68a0ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05d071a2735ca6a7db5957177ee1f2a3f4fbd4aa97a2f3d0b207ddef4f0f8963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcd7b8c5ae03c4a6d6bab0f49f931b9ebaca51828a8f0f12c96e081172446490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c1bb1b40ac9e73a01bc7af0837287b85d1032edad8608d1850d36981ae5ddc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff397683b6fcce1efc5b97a38afae99c4cdfec9c44f8c8c72b8ccbe6e369bb2"
    sha256 cellar: :any,                 arm64_linux:   "1c9e6df1851bbb0e9c48b9ea58559ea6921892ff16698d3df5d82a0cf14bd5f2"
    sha256 cellar: :any,                 x86_64_linux:  "153915efc332f3d01e81a53ba6d6e6897aff25626290d375fc8f8fc5d5cd0c32"
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
