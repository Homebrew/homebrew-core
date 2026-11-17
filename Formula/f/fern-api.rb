class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.217.2.tgz"
  sha256 "2d1894909be39d8e602f0ca1d458363c99cecb17243763174c57dbd8e0dce7a0"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "30c27b7926bef2de9223022c39e255b4834d8d3f4560df6c291457e3ad905224"
    sha256 cellar: :any,                 arm64_tahoe:       "30c27b7926bef2de9223022c39e255b4834d8d3f4560df6c291457e3ad905224"
    sha256 cellar: :any,                 arm64_sequoia:     "30c27b7926bef2de9223022c39e255b4834d8d3f4560df6c291457e3ad905224"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "630d55c7f8872e4043ff86e68b9b3e811b814f280526c19057fd1dd23d6ce565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0ce5bce7f87d6a21f5925f9e5d26d3d6bc4c78402f3041f5ff605d0ebcf9b84b"
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
