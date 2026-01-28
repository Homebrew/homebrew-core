class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.52.0.tgz"
  sha256 "13d76223f2209d3a415c9c20c11262642c9bb74f6e9d05233f3df4f643dd130f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2977bab581d85f48fbd8672f2d47bf720f3583c1e0938c124886dda8eeea9a72"
    sha256 cellar: :any,                 arm64_sequoia: "fcff33d725fac16e7b7d2958ec161367f7d04cba1164b85cda4db8445d986608"
    sha256 cellar: :any,                 arm64_sonoma:  "fcff33d725fac16e7b7d2958ec161367f7d04cba1164b85cda4db8445d986608"
    sha256 cellar: :any,                 sonoma:        "f3e59f0353735d9eb0ad50c0c19648ce225e133bd404b19cbc7c23e72fd9c0db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfbd990eb2f176aba560f9b184adf456748dce1fd90f758a0924e77b4c3c48b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03726ab46194133e4f9676bf72d6ab17123255c33aa406afa2354341ed14b532"
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
