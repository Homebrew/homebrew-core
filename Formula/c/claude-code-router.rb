class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.1.tgz"
  sha256 "e54b364e6b8ae498f4ca8d57a4214de4646c2d21d1805842988b5b53ab93f8b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1039700a02c7a6e8ec8f0bb589a2e2cbfcef3592bf23a7178456d7b6241802de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe2b6b625e767e1e21196e7d5dc5f9725da8ebc2517808a1edc0927546bca256"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa4fa93e83028b41d499ca8fef603509ca57c218fb70518057b2c14dddf0fa28"
    sha256 cellar: :any_skip_relocation, sonoma:        "212917c9f26c1a31ea9467b1cfbcaaeb613d57e2ba6497d566c903b6af642eba"
    sha256 cellar: :any,                 arm64_linux:   "64511827a66fc4447e6907b842a3d99b4c27db2ee38bf11653c7a7079b73aad6"
    sha256 cellar: :any,                 x86_64_linux:  "4ac9842f3c396989b23ebfc0750d98e28c5f51c64a5362490490b8bee7529c0f"
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
