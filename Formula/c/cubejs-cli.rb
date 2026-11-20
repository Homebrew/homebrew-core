class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.8.30.tgz"
  sha256 "8b0ca0d5348bebb40b9729f30c2cfc11b6bc01e87690995da719b0579e6d8845"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e00801a6cff41886ffcb87ac888f4a7e561255b5d4906532bb3868492bf29cfd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e00801a6cff41886ffcb87ac888f4a7e561255b5d4906532bb3868492bf29cfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e00801a6cff41886ffcb87ac888f4a7e561255b5d4906532bb3868492bf29cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7052b9e78f893955ce12a317b919d9409e268f0884275a190dea59e201342913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7052b9e78f893955ce12a317b919d9409e268f0884275a190dea59e201342913"
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
