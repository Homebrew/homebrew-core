class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.20.tgz"
  sha256 "33907b0aa531501627ccd1f3e9f1fcd6688d557b182742fdf99f0ddda79dcab8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0028b5164cd8d8de432c7a4d72c440454b550ef240dcbc85a83bff4321fad0eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0028b5164cd8d8de432c7a4d72c440454b550ef240dcbc85a83bff4321fad0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0028b5164cd8d8de432c7a4d72c440454b550ef240dcbc85a83bff4321fad0eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ab684b27fb932c13cf757dc48baafee38a8a13906f0619d0f98afb19738a528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ab684b27fb932c13cf757dc48baafee38a8a13906f0619d0f98afb19738a528"
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
