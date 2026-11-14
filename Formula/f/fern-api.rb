class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.210.3.tgz"
  sha256 "4eb620cdbec2b3b2f69abc1a1d2ac3058dc1230d6efaeb78615981e102e2b07e"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8fddaee26bbe21ea2fb0094ccb46881b22e74bcf9404d953cea30e4dfc3b6ce0"
    sha256 cellar: :any,                 arm64_tahoe:       "8fddaee26bbe21ea2fb0094ccb46881b22e74bcf9404d953cea30e4dfc3b6ce0"
    sha256 cellar: :any,                 arm64_sequoia:     "8fddaee26bbe21ea2fb0094ccb46881b22e74bcf9404d953cea30e4dfc3b6ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b7c4072f21f7fa7e56bb8f37793c2cec6ceb0f1242d5d1a131bd21b6fe123c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6aaaf6ea78f0bd27b5de2f9947d6b729af62e84dd436ce83d59efd8b5a4761e4"
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
