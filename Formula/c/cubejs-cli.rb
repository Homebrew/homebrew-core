class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.21.tgz"
  sha256 "92ae34096cc9a9e9e2908e49b37e5137b952f1417e25e845237c7dd4069c1518"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85908dda0ceaea70e0c88302edeff63e2db1be07d2e0eca030568b02254d06ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "85908dda0ceaea70e0c88302edeff63e2db1be07d2e0eca030568b02254d06ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "85908dda0ceaea70e0c88302edeff63e2db1be07d2e0eca030568b02254d06ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0d53be482ca06924796261e09121c20776ffa985c1a444b480cd4a8bd38bc425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d53be482ca06924796261e09121c20776ffa985c1a444b480cd4a8bd38bc425"
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
