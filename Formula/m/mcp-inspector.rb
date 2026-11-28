class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.17.0.tgz"
  sha256 "3691c0e16f17205595e9fb42ba11b5558d175e2ad0cdbb8d5fa79b7ddcd13c1b"
  license "MIT"

  bottle do
    manifest_sha256 "1f59c8cf65cb437754c5594cd0b36f59731ba32c9e3c5e4de6cda00fa8affe46"
    sha256 cellar: :any,                 arm64_golden_gate: "81fca6a7f18cc55c846175a1e341910e666000bedfafdc33a5e039ed35bf6c1b"
    sha256 cellar: :any,                 arm64_tahoe:       "601ce86b2e21fe61fd89bc42e6e6fe943be4c23ded718d21a9847243a32ebb2d"
    sha256 cellar: :any,                 arm64_sequoia:     "217eeb668c7bc33575de6a78dc1a5c0aecf45f8bd030182054d3cf6298cf5985"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "12b7ae810dc54767d12fb40f917bd254fa00b86990374742ee6609ba1f38a293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8953352dc2afb4bdd5cfd5394669389411c781ff1f32733d2a69963fee65a151"
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
