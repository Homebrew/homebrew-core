class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.216.0.tgz"
  sha256 "25929e1bf0047e36bb83bdc53d1f2368741f179c8a29e92ca04ae0dff1d86d94"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5203589bc3f39c82f82cbea627ac823a020fe073577ae45e477a8214c35d1921"
    sha256 cellar: :any,                 arm64_tahoe:       "5203589bc3f39c82f82cbea627ac823a020fe073577ae45e477a8214c35d1921"
    sha256 cellar: :any,                 arm64_sequoia:     "5203589bc3f39c82f82cbea627ac823a020fe073577ae45e477a8214c35d1921"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "78533f665c2f49d46875367221077cf46bf4107d4abf205ed8502d05e61d5061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "172bd2331efa8f740903797a5bda68c02357695b4b873e9b1b7d9379f378dc9c"
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
