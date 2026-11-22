class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.227.0.tgz"
  sha256 "f6202d70969fe367f5f51db5d778a0a496c6d73e1f270f377935c1f59e3fa4ff"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "58d837a3e895a3967ee23a099cc00be255222740002ac54f8419e88fcbbf9ae1"
    sha256 cellar: :any,                 arm64_golden_gate: "59e5c7498064085a567223c27e3196c3943764d9491fcb3f71bfcbb099235d23"
    sha256 cellar: :any,                 arm64_tahoe:       "59e5c7498064085a567223c27e3196c3943764d9491fcb3f71bfcbb099235d23"
    sha256 cellar: :any,                 arm64_sequoia:     "59e5c7498064085a567223c27e3196c3943764d9491fcb3f71bfcbb099235d23"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6d7de4d56e2dd07a79e6520737a97ecd14b996d2263191a41a33119d498961f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7d9b0f722cf92fc1497ca264e044d6f8095024c617e20ae3d660d12fc1caea02"
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
