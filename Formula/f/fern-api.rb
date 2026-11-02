class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.191.0.tgz"
  sha256 "42f21e4e4d3555260ae2864acb80627314b6dc3c2f7e5cce354fff03318d038f"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a19c4f4f4aafc54a78270187dc7a5de0c15c54c3fca5b52ec803daecf7349a81"
    sha256 cellar: :any,                 arm64_tahoe:       "a19c4f4f4aafc54a78270187dc7a5de0c15c54c3fca5b52ec803daecf7349a81"
    sha256 cellar: :any,                 arm64_sequoia:     "a19c4f4f4aafc54a78270187dc7a5de0c15c54c3fca5b52ec803daecf7349a81"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6c309bef716e38f3cb10541dff4364a420a3e471e92f2a47bf72acce022a379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5c13dc21dd9183710a8b70fb755668afd7ebf72d420972940b161355bd0e8079"
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
