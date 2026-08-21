class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.21.tgz"
  sha256 "dca6ce2544e86b33642a949643a946e8d3c676b6ab0fd4d2f0548849e3d7141a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b231fbd242e6d92d8802d8bc9ab445c1bda51a635fb6db86fe59c45e9212afe8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aee9fa66d287a24658f16a56a5283033804b291b813d2804a54ece43cda76b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51f95d21669854ef44bb3b022585df28bbcd0987aaa78c119470e34ed6684859"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce8a05e6df1ba15ac4899f155360e758d583a456d50576a7553a8b472c01c65e"
    sha256 cellar: :any,                 arm64_linux:   "605c46012e6e64403896e5df8a406bed44033ea827d5ace5a6505f452806879a"
    sha256 cellar: :any,                 x86_64_linux:  "ac6790d085abf8bcbbba25d4895d03d2d8fa7753cfe48e4c3ee15457f5f422c3"
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
