class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.23.tgz"
  sha256 "77aa72e66d78a614792b6f140cb044b8b5eb53e18dd5ce52848c191ae5d16cdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e13e08a25ee975a9bb0ecef3f82316bb6ffc47909e8237631d50fabe16e1ee5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e13e08a25ee975a9bb0ecef3f82316bb6ffc47909e8237631d50fabe16e1ee5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e13e08a25ee975a9bb0ecef3f82316bb6ffc47909e8237631d50fabe16e1ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b620036e0f67b6f86d26e17ee2802334892f5cbff30a63971209e5241f39f1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b620036e0f67b6f86d26e17ee2802334892f5cbff30a63971209e5241f39f1d3"
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
