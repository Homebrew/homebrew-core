class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.27.tgz"
  sha256 "3a0bff4e085669cb0e11dc62a407d819e8d0db69ee516bee8581eb6d977a1138"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bf2d207c8f6a0111bbf19048518120fe813e26f29e1183053533e9742ac66d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bf2d207c8f6a0111bbf19048518120fe813e26f29e1183053533e9742ac66d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bf2d207c8f6a0111bbf19048518120fe813e26f29e1183053533e9742ac66d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42f18f6e536b13f324cb895adab49ae86413930bc9c2dd793e43af6e1d2f65d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "42f18f6e536b13f324cb895adab49ae86413930bc9c2dd793e43af6e1d2f65d4"
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
