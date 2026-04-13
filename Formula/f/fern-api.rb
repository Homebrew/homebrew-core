class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.67.0.tgz"
  sha256 "4f99272fa2c1a4f2c998abb8d2c636c0e4c824bdfab61430634cd2c4428383cc"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70cb97bbd3320b6a640c99775b14548ae03f5d743cb2b4900f3d98d3a1ddaec2"
    sha256 cellar: :any,                 arm64_sequoia: "58a4b272802014f23e529bdcf687fd957dbc8133e61cb66f21d93595835a8292"
    sha256 cellar: :any,                 arm64_sonoma:  "58a4b272802014f23e529bdcf687fd957dbc8133e61cb66f21d93595835a8292"
    sha256 cellar: :any,                 sonoma:        "eae0e00e9d2307f5197b82e32d493f7eefe73b05daff4133b494418b13b958b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bb161506d4c5eae97f3f90c19801ddd7f50654fd12c73f98f998aecd6383b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b29307c122a22272d055f3fa943efe462d1ea27738625bf158897f83f348d5"
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
