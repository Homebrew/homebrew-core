class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.30.tgz"
  sha256 "8b0ca0d5348bebb40b9729f30c2cfc11b6bc01e87690995da719b0579e6d8845"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d311ebda901b71643cdc4a9aa8681f8b5bbe8b144b9679a303798ad7f80fb74b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d311ebda901b71643cdc4a9aa8681f8b5bbe8b144b9679a303798ad7f80fb74b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d311ebda901b71643cdc4a9aa8681f8b5bbe8b144b9679a303798ad7f80fb74b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3917d3c8b72ebbaa8c4009f59f5d21f0ce34de3b6cceb269df68e477ea0fe5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3917d3c8b72ebbaa8c4009f59f5d21f0ce34de3b6cceb269df68e477ea0fe5fc"
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
