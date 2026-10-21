class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.11.0.tgz"
  sha256 "f316f4e4cb25f8ea052c733cad14b530c6eb6e89f6f9b9370d7022e49ab8b757"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ff2fec0db8c9ad61813f91d02dd3fcf7d61179fbb233e24045bc6031f5f5bc11"
    sha256 cellar: :any,                 arm64_tahoe:       "19b59f7c15b93e3b20a7c3e16aac4d67672e0a4611bba387d3432907c412ce79"
    sha256 cellar: :any,                 arm64_sequoia:     "7dbe474fef0aa55ea26bd78bed227504b6970e04ba33c208807aac6d52e47d25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47753509e02f0d1eea7a015da155dbd1331e9f0f03933f84f729e0c9354ab224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3f595d98ad1a3ebe0d6a4e2fabb2f62f45431b20b12c15ded5b9a0edeb805fca"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown/archive/refs/tags/v1.2.13.tar.gz"
    sha256 "f22d36d1dc3fc068274149b5e699058657a3f7da1802aee42e7e667f3a31cf04"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b1f4847eb61306e8c4f1a0418bf9e47231e8fdbc41a88631777d5cfa515eaaaf"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    resource("rolldown").stage do
      system "cargo", "build", "--lib", "--release", "--locked", "--package", "rolldown_binding"
      dylib = Pathname.pwd/"target/release/librolldown_binding.dylib"
      node_modules.glob("@rolldown/binding-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@napi-rs/keyring-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
