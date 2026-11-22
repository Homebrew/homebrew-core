class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.32.tgz"
  sha256 "8942b92c940b3c2e34676294727188fcdc796dde77d4930ebd89fece73276468"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "5339075e7983b037d03a56d3bc4363904cd87f33c07a4ad0bcef1d13fa5cbca6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfebb806bde23d30cfbfc082efeade93b46b83e14040ad5914b4c4aa80e94eb5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bfebb806bde23d30cfbfc082efeade93b46b83e14040ad5914b4c4aa80e94eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bfebb806bde23d30cfbfc082efeade93b46b83e14040ad5914b4c4aa80e94eb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2c8a1f628f459794867ba6c8ad3f3535dbe382bdb10b0385dfbbed615d6048df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2c8a1f628f459794867ba6c8ad3f3535dbe382bdb10b0385dfbbed615d6048df"
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
