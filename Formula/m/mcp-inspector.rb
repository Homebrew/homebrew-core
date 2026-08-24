class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.3.0.tgz"
  sha256 "e1f8609e6773d7e06e9293d900eaefac5e9f331e6c8709f6a86e1f727be9255c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ef827d6a72dad963a593859cfc17b5c2bfc14f6de660bad73afbe86c98ce6aab"
    sha256 cellar: :any,                 arm64_sequoia: "f444ba67eb44791136298368bfcd5c50c9a37bb91d266b3936fda23d9edf4f4c"
    sha256 cellar: :any,                 arm64_sonoma:  "378c4a5fb56cc527e35f7c8cad03476764f7d7c8b37e5459eee18e09dfff41d8"
    sha256 cellar: :any,                 sonoma:        "5ee4c87602608341667deee4451b243b0019234c449c235017803f603a5d138a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da6993fc99d8e69467472febc1885bdfac4ff702c3e03cc1c358bbb8f6543267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e924e687b8ef0a5c8187c305573e0937a6c80bc756e112f8e2df2f761f31a83"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://github.com/rolldown/rolldown/archive/refs/tags/v1.2.1.tar.gz"
    sha256 "05615e3dd0991fe24070626ed80e18bb95a253faa865d45e5b86e65057672d73"

    livecheck do
      url "https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v1.3.0.tar.gz"
    sha256 "349be987e7582e6aa26763b2de96c4cbbd0d3cfba2417d9733524589fdbc275f"

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
