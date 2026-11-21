class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.224.0.tgz"
  sha256 "f6f0760ffe3515edb8686040b1bf564729916829f70502392cc96595f913cbbd"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f8781a0b921cbadade1617d8ca4b7744f04232678d90d69c7670535a3ccc40f3"
    sha256 cellar: :any,                 arm64_tahoe:       "f8781a0b921cbadade1617d8ca4b7744f04232678d90d69c7670535a3ccc40f3"
    sha256 cellar: :any,                 arm64_sequoia:     "f8781a0b921cbadade1617d8ca4b7744f04232678d90d69c7670535a3ccc40f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "044dfa87c17cde6804337ed12670acff80b15ee1acba0b7a17fda922b53e6866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cb28d5613ca18df4afb4d772e86f80d10db60fd01ea739497b22e2c9241183ec"
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
