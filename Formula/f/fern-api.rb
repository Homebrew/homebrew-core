class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.205.2.tgz"
  sha256 "b11239a1f89030e6b8680a72fea5add1c372a0d9a4cd32054316c8e87c0339d6"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "0b327971995cbdee0a3a0a16b14c29b62216a89cf3f9b0ac6a7b7bbc65ff99ef"
    sha256 cellar: :any,                 arm64_tahoe:       "0b327971995cbdee0a3a0a16b14c29b62216a89cf3f9b0ac6a7b7bbc65ff99ef"
    sha256 cellar: :any,                 arm64_sequoia:     "0b327971995cbdee0a3a0a16b14c29b62216a89cf3f9b0ac6a7b7bbc65ff99ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e2bf6021fa4a939e70cba31e47be0191e38c489f4a2f358b68be85418486c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d2864ff43551e2ea0d309981b05e369295bb3a6910d25eb99893f69cbc2ba345"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
