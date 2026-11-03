class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.193.2.tgz"
  sha256 "bf69ff492a3ab6bc5ff890eff0060fd59ef9612eb9d3b30697dfbe6c16fbd059"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "68f989fe6297dd636683e34206d7410daf8730647fc6c4fd1ea1f08bf2b134e1"
    sha256 cellar: :any,                 arm64_tahoe:       "68f989fe6297dd636683e34206d7410daf8730647fc6c4fd1ea1f08bf2b134e1"
    sha256 cellar: :any,                 arm64_sequoia:     "68f989fe6297dd636683e34206d7410daf8730647fc6c4fd1ea1f08bf2b134e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a6b6d1ce8d9b620a4f29087e0e1e8df9b1df082293d3b4a0988c3cd1eede96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1cc8b082ca9c0df1aca653a69066c55bb7a8c7ba89651dff1cc8bce8f205d100"
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
