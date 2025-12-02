class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.14.1.tgz"
  sha256 "8457f03e23e4efd455900cb96048a36b992273f42098e5b2fb0fbffa30f67678"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78b5b30b0343f76c72e7fc67429fc9d6daa07419572ed13964b8ae9bdd42a53c"
    sha256 cellar: :any,                 arm64_sequoia: "4f4542cddcd6dfc0a7f80f8ad5db538e9a79d1f9f0d1e0ed32f6811c7d50b66a"
    sha256 cellar: :any,                 arm64_sonoma:  "4f4542cddcd6dfc0a7f80f8ad5db538e9a79d1f9f0d1e0ed32f6811c7d50b66a"
    sha256 cellar: :any,                 sonoma:        "65832a3ee373f2a84761fc93caaa8f2d54ebb1fa8bca40ac1505a90486c4dc73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "579c82ac44c3cc3b527cb1c71976ff2b1289287dc3fca180a9f65a7bb2751f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12b01cbf8da4533e5a8bc9284dc81d7edbb69a469c237da0df70b0f39ac11814"
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
