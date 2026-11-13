class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.15.0.tgz"
  sha256 "cea18749b290e23d8b8b790c8ba79ee19870b398db3d4492d544a61373f697f1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "23c7a9d43af939a96922b6c31279b945e0bd0e1f9f831dcc8c4649ed59e4df04"
    sha256 cellar: :any,                 arm64_tahoe:       "4deb7916721fafdedc52c9a4f9e15ce84892961fb7c1aaf4bd960a904a8a92dc"
    sha256 cellar: :any,                 arm64_sequoia:     "9cd637d3d1e5f7b80837b411a70241c029d1c5a39677b18f604acdf8bf8bf9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b6f9835e5b388a543bf4276bfa84b0a758d91f231c8c4e80e32c3c01a6ca4b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "01043ea453c067121245998515fb8c539da4b8292a448e6a42e4f239e75bc6b8"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown/archive/refs/tags/v1.2.16.tar.gz"
    sha256 "4caefdecedcba5a0c182fabe4d51f72dac72358b31ee0df6f1ab5be0d81ec5d0"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.2.tar.gz"
    sha256 "b461a450df324a73219c6352186b95e4501b3f9099b876b023c9cdcf1d8cbf9d"

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
