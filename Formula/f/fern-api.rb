class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.201.0.tgz"
  sha256 "c31bc3afe99ab35e20fc09aac46a63512bf2cc1440c1d26cf85c4c280069a3de"
  license "Apache-2.0"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "4f0bfdddcc0dd6cd7c715a688d2d3f6be96fc430eaf1b1ed8543e6d197d4e95d"
    sha256 cellar: :any,                 arm64_tahoe:       "4f0bfdddcc0dd6cd7c715a688d2d3f6be96fc430eaf1b1ed8543e6d197d4e95d"
    sha256 cellar: :any,                 arm64_sequoia:     "4f0bfdddcc0dd6cd7c715a688d2d3f6be96fc430eaf1b1ed8543e6d197d4e95d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1af8deecd6b4982511480afc19c039cdcbd0f9adf38497afdb73b19fa5ae13f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4df5f0fb7a728d69c99e2ce0cbe5b9eed43c9a8e0cfadc437d2f75cacbbcbe0f"
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
