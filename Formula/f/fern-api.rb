class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.195.0.tgz"
  sha256 "0aabbd4e600ca5f8e46b5ceb098cfe9d1a0cea72809013a94b525863aecc2098"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b8d1d0534c66cc23850f7cdfb7870a04b592bed9159f2a59e163ca61a38a13f2"
    sha256 cellar: :any,                 arm64_tahoe:       "b8d1d0534c66cc23850f7cdfb7870a04b592bed9159f2a59e163ca61a38a13f2"
    sha256 cellar: :any,                 arm64_sequoia:     "b8d1d0534c66cc23850f7cdfb7870a04b592bed9159f2a59e163ca61a38a13f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ff76316e376f160545344a703b053d54f9f9af9e79fc738fb34553e49b9959fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "13f0296848e9037fbb16c2593f5f1f7cf4a3e622e65b9736184afff5af0c9eb4"
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
