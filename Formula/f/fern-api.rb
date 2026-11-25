class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.229.0.tgz"
  sha256 "c489c2b28dea9ce76b4dc90e7988f9a8fec8558eff0bc1fb9baebc1a65822304"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "3221392234285363b13545572768999727841d90610a3011d5231140baf68e17"
    sha256 cellar: :any,                 arm64_golden_gate: "eaf436bc519fe3a1ac061a693a6e85cfaac9c4d31942c4141bae1f4bea92365b"
    sha256 cellar: :any,                 arm64_tahoe:       "eaf436bc519fe3a1ac061a693a6e85cfaac9c4d31942c4141bae1f4bea92365b"
    sha256 cellar: :any,                 arm64_sequoia:     "eaf436bc519fe3a1ac061a693a6e85cfaac9c4d31942c4141bae1f4bea92365b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec314fc1cfcf16f402425c92248dbae73a75d15d831b464386574068880552ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "20e163d575c7ef0c8fc16912f695232d95b5216c2c5e1df6ef909c0e60100685"
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
