class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.47.2.tgz"
  sha256 "f9a1a6c4e228e0dc78d9bdcb08db4f4209a82b5ea9fc50dde741e84346f4fffb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dcb35edb5d56d4f364be271c0c6656ac31919c169e5effb130d789137e09ef41"
    sha256 cellar: :any,                 arm64_sequoia: "05f4c055056d9e80264beda2ae4199f2138cf215707a2488935cc638cb3c61f0"
    sha256 cellar: :any,                 arm64_sonoma:  "05f4c055056d9e80264beda2ae4199f2138cf215707a2488935cc638cb3c61f0"
    sha256 cellar: :any,                 sonoma:        "f05269d5724ad1fb7d99eb88c00789fbb47d4aa5e405f130c24398e2e37e5c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9348d7a62d8c088adb3f0a45f71d3688eb1ff0330232546773856946205135cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13616abfb1a90bb9939f2f573545d9fb408c416c77cc1ad0305f4dbe68e4bc37"
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
