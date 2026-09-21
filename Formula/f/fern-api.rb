class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.129.0.tgz"
  sha256 "5903752e20bda27f143eddf38a312000dd04162a4e5b1ceaef9a5bc58744212d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "53a5dcd6ce3ff293260dbd9f7437690de873c7f02361404788db1b4a9d309de4"
    sha256 cellar: :any,                 arm64_tahoe:       "53a5dcd6ce3ff293260dbd9f7437690de873c7f02361404788db1b4a9d309de4"
    sha256 cellar: :any,                 arm64_sequoia:     "53a5dcd6ce3ff293260dbd9f7437690de873c7f02361404788db1b4a9d309de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c6e934af4d2af917d2eacd16e5843615d0244466ab4fd1cec804d1e478ec0a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "247b139862b766fcca452ecda6d6445104b46275fd6569f67f869d71b5102bdf"
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
