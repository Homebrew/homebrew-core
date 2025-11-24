class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.5.1.tgz"
  sha256 "ec74f8c08df6fb3343a9a72b7fd17e46d2695fab494add2bcb9f3584e3ae59bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "24a0c30e4458fb3bc2a60d59eca38fecef5691aaf9cc3bcf9922054813eb64c9"
    sha256 cellar: :any,                 arm64_sequoia: "7b42971ca12b4baef8da9c962df072cedda379a3ff293064f8134fdb6dcf9c32"
    sha256 cellar: :any,                 arm64_sonoma:  "7b42971ca12b4baef8da9c962df072cedda379a3ff293064f8134fdb6dcf9c32"
    sha256 cellar: :any,                 sonoma:        "34366588180e0eb2e8ce745ef005541d340392adb31722725e06ce66d1379789"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "149c0a4c85b9c162562b4e79d96094cf7b53cba2493c3834a38b00d40de95fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5741ccca04e563703bcf38850c81c6fe0219dceeba63f638d84e7c361e74405"
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
