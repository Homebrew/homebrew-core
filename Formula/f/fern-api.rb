class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.199.0.tgz"
  sha256 "ece160abcc05202251fc1f165a402c66f4ad9144d05d6b4c6cf4162b4d22e779"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3b808319ef4c6e5fe33e331e3b88683a30d4e0f2aae5b5e028dc5b668a0fc49d"
    sha256 cellar: :any,                 arm64_tahoe:       "3b808319ef4c6e5fe33e331e3b88683a30d4e0f2aae5b5e028dc5b668a0fc49d"
    sha256 cellar: :any,                 arm64_sequoia:     "3b808319ef4c6e5fe33e331e3b88683a30d4e0f2aae5b5e028dc5b668a0fc49d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fabb35ed6b1cc84ed30f13c8f8726ce1874ddf7d881415cc1248821e43eb63b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "318a976a2f975481a00e43c2bec79f0919e27ff74d3b17d3291ec3135659f896"
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
