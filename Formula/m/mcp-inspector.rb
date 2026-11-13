class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.15.0.tgz"
  sha256 "cea18749b290e23d8b8b790c8ba79ee19870b398db3d4492d544a61373f697f1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "43eca6667ad3096499098d89409b3086001805540ab3321d4262efcc8cc7454b"
    sha256 cellar: :any,                 arm64_tahoe:       "8a7f6fb721a9d7072a97c7635128923cb8c1125f68e73746863f5f818c41c9ed"
    sha256 cellar: :any,                 arm64_sequoia:     "a93f39bb943b3d10c5f4d3e85cf813656d2b3ba464cfeb180f93dcf0d8e4115d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df7cb2433f4cf4c08f090492add4f6dc628c5c35399d5f132d3942f97467e545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "658dc44031f78b9ec60515fef6c31f232a9d362eaefa39c6e1a05a25f9984235"
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
