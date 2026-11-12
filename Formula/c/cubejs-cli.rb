class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.22.tgz"
  sha256 "b577030c13dcff03fe6a6c72a9fccf28f3ce9b97593c0987fcb34aec36162444"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4470a4cdd258569499db6d4c19736ed4853b86d258bca2c7822af702d170dae8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4470a4cdd258569499db6d4c19736ed4853b86d258bca2c7822af702d170dae8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4470a4cdd258569499db6d4c19736ed4853b86d258bca2c7822af702d170dae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ab1636f5468aa45f68d4e56872aa1f4478f7b450fb1a682182ae96efd166437b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ab1636f5468aa45f68d4e56872aa1f4478f7b450fb1a682182ae96efd166437b"
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
