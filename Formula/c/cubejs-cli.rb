class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.25.tgz"
  sha256 "4cf9924014aff5257668b2cf46ec9daa2ec28f7661eb76cfccb100a770fc7026"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4195cebb546303569c61270d21edc0bf4baed9d2c3a0131943b143361afb31c8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4195cebb546303569c61270d21edc0bf4baed9d2c3a0131943b143361afb31c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4195cebb546303569c61270d21edc0bf4baed9d2c3a0131943b143361afb31c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6145e4ba22e2c3e3f2a555acc16d3e3bbb0f333e2e13bfb377c05778148d8aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6145e4ba22e2c3e3f2a555acc16d3e3bbb0f333e2e13bfb377c05778148d8aa"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    ENV["CI"] = "1" # Disable telemetry.
    token = "eyJhbGciOiJub25lIn0.eyJ1cmwiOiJodHRwczovL2V4YW1wbGUuY29tIn0."
    assert_match "Token successfully added!", shell_output("#{bin}/cubejs auth #{token}")
    config = JSON.parse((testpath/".cubecloud/config.json").read)
    assert_equal token, config.dig("auth", "https://example.com", "auth")
  end
end
