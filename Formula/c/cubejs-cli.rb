class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.16.tgz"
  sha256 "b8e83f6c49d1e0265fb674ac036f21998e6044bc0bc397a88d4b178047545451"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "473c2f94eff403f81fe830b6f0d8b90442536104a51e293b0a930b5381f68be6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "473c2f94eff403f81fe830b6f0d8b90442536104a51e293b0a930b5381f68be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "473c2f94eff403f81fe830b6f0d8b90442536104a51e293b0a930b5381f68be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ae164588df07b6fadbe0712a91a833af89be9b53dad80173fa3be8a5bc79b6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8ae164588df07b6fadbe0712a91a833af89be9b53dad80173fa3be8a5bc79b6e"
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
