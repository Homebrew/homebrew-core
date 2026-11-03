class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.17.tgz"
  sha256 "c140d9cf80bdf7bd98802687e92d7d784aebfa9d3c312391a8b95dea8a6320ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdb0d8b7fb5fbfb31dd675662c7834eb68d0136d10e17a4effa348850eda304f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdb0d8b7fb5fbfb31dd675662c7834eb68d0136d10e17a4effa348850eda304f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdb0d8b7fb5fbfb31dd675662c7834eb68d0136d10e17a4effa348850eda304f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7990e13408229dd8181c6c64625107ff922947c527c1bb1c994c7b8005d21bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7990e13408229dd8181c6c64625107ff922947c527c1bb1c994c7b8005d21bab"
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
