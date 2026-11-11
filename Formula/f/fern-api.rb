class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.203.0.tgz"
  sha256 "2649b263bb06aa1dd404ba0d7a525b2f1707433dd62f19da726c6e0f9ae4520f"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c4a0f9c46ac874be274dd2b3543637064f1ec8550828e2607c170a51604655f9"
    sha256 cellar: :any,                 arm64_tahoe:       "c4a0f9c46ac874be274dd2b3543637064f1ec8550828e2607c170a51604655f9"
    sha256 cellar: :any,                 arm64_sequoia:     "c4a0f9c46ac874be274dd2b3543637064f1ec8550828e2607c170a51604655f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ecc087f3599879c7f9c4651900f471b05d7b0205624695eda4b15c2875b845cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "93a5a18450fa076e097ee81503edffb5fb7c6e9e90a053e7fcbaa18da305d1de"
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
