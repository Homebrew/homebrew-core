class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.26.tgz"
  sha256 "8274e14782345751b3382f69194f610ac1bb192027e4201bdffc290758e99d83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b6aa330c12a571a9bd4394f9bdc97856c6dce9cc22f83afae62122a5ab4dd10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b6aa330c12a571a9bd4394f9bdc97856c6dce9cc22f83afae62122a5ab4dd10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b6aa330c12a571a9bd4394f9bdc97856c6dce9cc22f83afae62122a5ab4dd10"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8be0df6289205510c378f6f443505b496a5193389c3e5413c78f33ca30108e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8be0df6289205510c378f6f443505b496a5193389c3e5413c78f33ca30108e33"
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
