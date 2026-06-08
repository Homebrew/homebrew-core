class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.45.0.tgz"
  sha256 "2b9500e679d995aabbd23a6df03146624bb8870f7a2960fd44274f2f83a05743"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35d80fe7dd0e8b0802830473969ec88fe5383f273add63646be9c583c6215b38"
    sha256 cellar: :any,                 arm64_sequoia: "08769dd9ce4ed60dffddf37c4a37de63229a39e7b1b3fabed922e1b58ac232bc"
    sha256 cellar: :any,                 arm64_sonoma:  "08769dd9ce4ed60dffddf37c4a37de63229a39e7b1b3fabed922e1b58ac232bc"
    sha256 cellar: :any,                 sonoma:        "61921791263ac263e3c4643c5fd8219238c0561646f1695aa4f8c66bfefca50b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04cfabf589215cc95477f37843fc2b70a868632b488885a73aacfce9501c1b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93d7b7b963c03e45f398c8be3ad74e4a3cbc643605653b62f5a733e7cd6996dd"
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
