class Mcpc < Formula
  desc "Universal command-line client for the Model Context Protocol (MCP)"
  homepage "https://github.com/apify/mcpc"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.7.0.tgz"
  sha256 "f5a99edf633089474e3ca1dbd928c560eac63f1e8a5ff2d6f048b92d0cd4da8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "133aa6123bc71e255a44929aa1b23928a5d6ce5b9a969efcfbe844f315801022"
    sha256 cellar: :any,                 arm64_tahoe:       "7266522bd1ab9cd9056328cfd8cf7eb3d2623461736bd488f5e0f2ec58d82abd"
    sha256 cellar: :any,                 arm64_sequoia:     "327ecbc304ff413de5e21406532d578676d1c867dc6b2089af890869f0b20727"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "84650f7bb2578e6b19367083d031917ec7ea5e8170b09be1d1d4455d35aadca2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bb24070af515d7ae7ba4d4458c00658147ee18d6139985c3c966b3950b81e1c3"
  end

  depends_on "node"

  on_macos do
    depends_on "rust" => :build
  end

  resource "keyring" do
    url "https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.0.tar.gz"
    sha256 "dcb0381cf252c577ff5c0c3bb0d5dd0750fd04a528484e5dbfdfb3c1add12467"

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
