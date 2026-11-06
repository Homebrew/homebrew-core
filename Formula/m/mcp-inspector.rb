class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.14.0.tgz"
  sha256 "eeefd17411ab28a239717692b8101366a5fddf9d79b2a2a4d1320b5fba705fd3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8b6a5ed9bce639f7bb532bac6fe8fc6429688d41b08671699adc3d81907d8f4a"
    sha256 cellar: :any,                 arm64_tahoe:       "abb4a76cdad52c17466e73c24fb3e8bbd0a192c0c01e7d9d397088adc96bd339"
    sha256 cellar: :any,                 arm64_sequoia:     "23b9cac33fc6e293e7e2956a4182a52ea54061fd8ca5754ed8165468f9a0b2f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "125c9bdee7620bcfde16dbd404788589ae42345bde853fc50042446259e60e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a36d5086c4475c7e0c04395fd833db21975b412b66107150200349cbf650a691"
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
