class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.8.tgz"
  sha256 "2dd86bb00a7664a2d41f309df3d363b358e9176026f8722cb82870589ad673fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "430dbfd91eccdee63991821ab382a32c42a71d2ed5c1ace5ea99d213b6393232"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "430dbfd91eccdee63991821ab382a32c42a71d2ed5c1ace5ea99d213b6393232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "430dbfd91eccdee63991821ab382a32c42a71d2ed5c1ace5ea99d213b6393232"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98416559269ee3279fd4b9a0fd28fe60b7d92d30c9a1ba0403ee5191d001219c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "98416559269ee3279fd4b9a0fd28fe60b7d92d30c9a1ba0403ee5191d001219c"
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
