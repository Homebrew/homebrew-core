class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.190.0.tgz"
  sha256 "7c6e7af6453e2802cfe34372958c1dc1310706ecf6537f0d26553111277b2988"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "be7a2125c09ee8b4f6fdf5b12f62d3567150e4147808d8e3239e0cd85a895cfd"
    sha256 cellar: :any,                 arm64_tahoe:       "be7a2125c09ee8b4f6fdf5b12f62d3567150e4147808d8e3239e0cd85a895cfd"
    sha256 cellar: :any,                 arm64_sequoia:     "be7a2125c09ee8b4f6fdf5b12f62d3567150e4147808d8e3239e0cd85a895cfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "609e5881fa285ff58d53c71270bd83ecc48d718551dc09504b15b37973d0fb9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de155e29e652d5e3cb192704187c48fd0551b9441c5cf96d8f4f43930a6ffa39"
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
