class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.37.10.tgz"
  sha256 "ef516b459030461d2c1b969f2ad0431974eab1a624a0d572b2f9ebbe9c3cc3f1"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "282979ec0c360a8d0b83819a87b414828aec05fed33c7b1fa8c1502a362c78ef"
    sha256 cellar: :any,                 arm64_sequoia: "578d6f8884fa9138377bfc468f244b1f4143383a234d68133736d064320114df"
    sha256 cellar: :any,                 arm64_sonoma:  "578d6f8884fa9138377bfc468f244b1f4143383a234d68133736d064320114df"
    sha256 cellar: :any,                 sonoma:        "5c969538bdcbec7641e6a44c3d65fd5bb20b12802d8444798ced570d4b005194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "905f28e179071f26862c6d3664e0ca796d6e757bafd22f21f7751a733aaee965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55be7f3b4d5167a8ba20b1d6412586eaf4166ea75954a60b678b955a7b9e3b9"
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
