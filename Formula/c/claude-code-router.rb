class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.1.1.tgz"
  sha256 "3a7cb06f392090ad77fa9174ed412c4e408b926c96bcb511b62140bd6bebba5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "679068419a44d4621d4a6b3538bdb9a4725635ad02d356072c1bf070711c2e9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0e7272fd0f6dd983bfa7206bb234b0ef6c6a52e5b6bbba61fcb5eb58c369cc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aac2b599ec7acdb4e41134d240b6d67f18bbed16a3418674fcd26e982a8c1f43"
    sha256 cellar: :any,                 arm64_linux:       "066e3b59fd0f4b0762b50d1e7d8feab01754d17679678146a20689e657d2e04b"
    sha256 cellar: :any,                 x86_64_linux:      "60743f741ffda09220af853380341d8c08bd514b02e5d83e447a414be8c25d02"
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
