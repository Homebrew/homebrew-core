class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.34.tgz"
  sha256 "1ff02a65e7fa5584ce870246868630dec9ff5c062a154496a2c7e54b46ebb70f"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "4daa9ba715cd7734d42961b67a53672046dbcda6e88a277abd82b29b4517eb29"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e46a4a17597d77d33ece4f570f45732a2cc607b953a9d5f7cab50dfb83743730"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e46a4a17597d77d33ece4f570f45732a2cc607b953a9d5f7cab50dfb83743730"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e46a4a17597d77d33ece4f570f45732a2cc607b953a9d5f7cab50dfb83743730"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac4d16c33956905cea44925097284176a1be7d4839ff6b877d2c24ce64268d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ac4d16c33956905cea44925097284176a1be7d4839ff6b877d2c24ce64268d88"
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
