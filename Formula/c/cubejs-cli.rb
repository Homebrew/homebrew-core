class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.28.tgz"
  sha256 "ce1a5ad10a312f04bc7c3d0b2deffe31781f585152786488e6f5ff7b566f75eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d11aaf4906f580c8689028fe72f8cd5ac5f9a9079055a54b57a5f6a6e5af8c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d11aaf4906f580c8689028fe72f8cd5ac5f9a9079055a54b57a5f6a6e5af8c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d11aaf4906f580c8689028fe72f8cd5ac5f9a9079055a54b57a5f6a6e5af8c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3113b9dc11b74d8c423d7ff8837159d923427baad6a330b375119510311c476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f3113b9dc11b74d8c423d7ff8837159d923427baad6a330b375119510311c476"
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
