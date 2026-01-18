class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.47.0.tgz"
  sha256 "b00afb2a6bd49a228ce41899e109e9f9d1aa04bd59b4bbd9fd3a5f73bc34d9c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a7f8da9959f5de55a3c8c7389c13464d6d83700231ef77b1fc2a7fd34a7a56df"
    sha256 cellar: :any,                 arm64_sequoia: "90bb430c61782b5d24ea9aacad1b367e8d7c50ddfd8f2c22a895294a5ce506d2"
    sha256 cellar: :any,                 arm64_sonoma:  "90bb430c61782b5d24ea9aacad1b367e8d7c50ddfd8f2c22a895294a5ce506d2"
    sha256 cellar: :any,                 sonoma:        "3b1a35e96159555c43c7b4221a55b7da93384302961699577a52ce2e7afa9e8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9fe98a10aa5fdb486deea0a79da8e4d12b4ed45772a96c4f231dabbc19b56c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5b08bd3535c29c261f9361dafa33980072237f733ba56e5ee41d462976c48f4"
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
