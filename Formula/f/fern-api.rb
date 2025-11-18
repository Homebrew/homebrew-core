class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.7.0.tgz"
  sha256 "bfda814d29b63d103cbbe4bec48b14aed4cde1ac3b8e45caa132b2b8fb0ff987"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eec0b02cf0e949b1d730212f93cd38db847c1cdd2993656bf7510c6425220130"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs" do |s|
      s.gsub! "await this.nudgeUpgradeIfAvailable()", "await 0"
      s.gsub! 'resolvedPath.includes("/opt/homebrew/") ||', ""
      s.gsub! "/usr/local/Cellar/", HOMEBREW_CELLAR
    end
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
