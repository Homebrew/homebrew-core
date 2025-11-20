class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.0.3.tgz"
  sha256 "605e16ea7bbe313862c8000f473048569c784f3c78220e80a16ca668bb78333e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d77781f6a9bd09210cdaf7603727c5acafc730933e3f071ed957e20130e203d6"
    sha256 cellar: :any,                 arm64_sequoia: "08f02681d8b157ec6c1b29a553b8bdc39d76fec45d25a5021e5a2d9268ccd84f"
    sha256 cellar: :any,                 arm64_sonoma:  "08f02681d8b157ec6c1b29a553b8bdc39d76fec45d25a5021e5a2d9268ccd84f"
    sha256 cellar: :any,                 sonoma:        "d752b0db9516699533a7b553a1ae04354071fea55756b0fb63264d561c462abc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372a92d83e87a8be3998624ea8750175bb088a82585c726c99d42925042538fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa9e0cd99889df3db8e34a160fc5699534b73ce9ee04c2e64d158d71c7f22bfd"
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
