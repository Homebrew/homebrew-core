class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.169.0.tgz"
  sha256 "9322d047ac8d2a55465a0660a0bf08efec894748b3d1f853d5bfe4b3c83eecbf"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "df14956dec6ebd930bea83057634043654ae64d042d0dfb070627c48dbcdb855"
    sha256 cellar: :any,                 arm64_tahoe:       "df14956dec6ebd930bea83057634043654ae64d042d0dfb070627c48dbcdb855"
    sha256 cellar: :any,                 arm64_sequoia:     "df14956dec6ebd930bea83057634043654ae64d042d0dfb070627c48dbcdb855"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4ecb0047d945f7f569a09dadb8f981d71cf74db9735d7758a39d61c616ce41ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2d6762eae426bc748d79e40395a47c0be0c14312d11b44d5939d9eaeec849e52"
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
