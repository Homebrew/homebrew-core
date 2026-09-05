class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.5.0.tgz"
  sha256 "1853aa695c9fd27169a9857574a8bddeb62140481eb7f4267188d2f86496cb80"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2a9d43144494faf39c261c772aea9f4fe6905bbd25e0ac022edb9d77e20d674e"
    sha256 cellar: :any,                 arm64_sequoia: "eece58135c64865215187c48cfaf75ab9902f4a7940b9045a2a73039f0201440"
    sha256 cellar: :any,                 arm64_sonoma:  "17a98ef974f3091795b4ceee548956e067f24d217430ac8ffcc2977430c40318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7662cfd0fb0b80cde828705add39e111e1cda73a2f1be7426475859443916ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a62bdc1aa7c412a4e232ed39d0c1be93fa11869d6a26a6f0455bfde8325260"
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
