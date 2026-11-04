class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.18.tgz"
  sha256 "0be2922ff8b8373841b4f30b9257082006981b4c1f3ce881b2d45a84dc5a3ac7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a8ca130a8056268a0fc962bbc6bb0d973a72399d1baa0b39f2f1412942d10860"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a8ca130a8056268a0fc962bbc6bb0d973a72399d1baa0b39f2f1412942d10860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8ca130a8056268a0fc962bbc6bb0d973a72399d1baa0b39f2f1412942d10860"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c03993b559d0bc8e2f624dc0d56e9143c55ed6b37774a56707e5a7ec11853528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c03993b559d0bc8e2f624dc0d56e9143c55ed6b37774a56707e5a7ec11853528"
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
