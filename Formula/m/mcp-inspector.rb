class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.16.0.tgz"
  sha256 "5283d65b609c80aea67a31cbc9668afbce036dba0e64f594c31c8826963e3a7b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "56a0d4e466208c6bb4230c129cf1108476447f2128cc0725d77c4f7e35cfcb47"
    sha256 cellar: :any,                 arm64_tahoe:       "a772ad9002d6883a0a2b68e7475b43f4603fddcd2659e7c687327fce913e7e89"
    sha256 cellar: :any,                 arm64_sequoia:     "ce0421a701f43d8714a45adee69b3abfc2a784498911862ccfd4e245f38a302a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e5ef8391ab9ac7fd9cb156ca5980af61f32f361799bbbc6c2caa48ce23a9cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c1b44fa862b1f546954778eab11eccc214a6ac1f670135d734d0b4a51522952d"
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
