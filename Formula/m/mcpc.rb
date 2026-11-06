class Mcpc < Formula
  desc "Universal command-line client for the Model Context Protocol (MCP)"
  homepage "https://github.com/apify/mcpc"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.8.0.tgz"
  sha256 "593387a3026351ee1e529fb211740768029efcccfef6e62f9cb6d1c20b78947e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9220739edcb5cb01b7709e27882204ac4f4b3835638e06a3740a7e45ec9102c3"
    sha256 cellar: :any,                 arm64_tahoe:       "1774a5515217084fae88a48b43f5b28e0e78739c21033a8ce10231063c8243b5"
    sha256 cellar: :any,                 arm64_sequoia:     "6609feb96edf54efabd26df35595d0d22b10362278ada43e44fce783fc271957"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96955a63c8113fe0eebe12aa2f207f2a2aa3b64f705bfb503adda1a566317e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e7f98a6361557a0ed72daeeb71d3564eb2f4038df6a60352a0a4458caa81d03a"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.2.tar.gz"
    sha256 "b461a450df324a73219c6352186b95e4501b3f9099b876b023c9cdcf1d8cbf9d"

    livecheck do
      url "https://raw.githubusercontent.com/apify/mcpc/v#{LATEST_VERSION}/pnpm-lock.yaml"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :yaml do |yaml, regex|
        yaml.dig("importers", ".", "dependencies", "@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcpc"

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@apify/mcpc/node_modules"
    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@napi-rs/keyring-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end
  end

  test do
    ENV["MCPC_HOME_DIR"] = testpath/".mcpc"

    assert_match version.to_s, shell_output("#{bin}/mcpc --version")

    listing = JSON.parse(shell_output("#{bin}/mcpc --json"))
    assert_empty listing["sessions"]
    assert_empty listing["profiles"]

    assert_match "Session not found: @nope", shell_output("#{bin}/mcpc @nope tools-list 2>&1", 1)

    # mcpc silently falls back to file-based credential storage when the
    # OS keychain addon fails to load, so check that it loads.
    keyring = libexec/"lib/node_modules/@apify/mcpc/node_modules/@napi-rs/keyring"
    system formula_opt_bin("node")/"node", "-e", "require('#{keyring}')"
  end
end
