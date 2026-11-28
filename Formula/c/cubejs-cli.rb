class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.35.tgz"
  sha256 "39418de51eb27ce9dfe4d2cf81b60595014c3d2a49085c8d2e44f31125963120"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7c6b58ceab714648ca3a6c2a9dbf766e653f8ac95a36f681f92f342782248dca"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0a5b89eb425019bec9ac5164910bf4ac8704f33cdc7f7da86c27baf3cba840a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a5b89eb425019bec9ac5164910bf4ac8704f33cdc7f7da86c27baf3cba840a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a5b89eb425019bec9ac5164910bf4ac8704f33cdc7f7da86c27baf3cba840a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d2d6339a8f20ca8a8e94af312362af9cba045814272dec80b892420365c673c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d2d6339a8f20ca8a8e94af312362af9cba045814272dec80b892420365c673c2"
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
