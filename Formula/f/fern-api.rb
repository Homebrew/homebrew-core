class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.66.0.tgz"
  sha256 "708f6683b999f01c8133398e3e2396ddc8a1add8bb1e5b6678778b3496d73618"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe46664d2079bcf567007c000fc1e9fb242bf90a18558c089b9bee959f324179"
    sha256 cellar: :any,                 arm64_sequoia: "6cde681ce60f30f6a1f4440056c29b44fb770a07921a822e3bec75264101eebb"
    sha256 cellar: :any,                 arm64_sonoma:  "6cde681ce60f30f6a1f4440056c29b44fb770a07921a822e3bec75264101eebb"
    sha256 cellar: :any,                 sonoma:        "f4ce4dc43e3e2b7dbb6eddd23acc57347e21905c599f10c805bb040443366b84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7518d6a7a7c63e2d5293f5bd5f5b50627d27acd46d290f786a5129e84a97bdcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be183e1bd5fa0540f815bc19e0472e7f2ade35377754f373f4488e767a9a954d"
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
