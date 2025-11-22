class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.4.0.tgz"
  sha256 "ee04bf3a1dc12b085bd7498da880c31c1c467cbea2683ff98667c96f420762e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2804aca743d006dae88f89eb630cce2a582c5742aa314b7a41814a277324fd54"
    sha256 cellar: :any,                 arm64_sequoia: "fa495d255538bc4388b672c29fc3af585113aacb32cb82e483db64808b882113"
    sha256 cellar: :any,                 arm64_sonoma:  "fa495d255538bc4388b672c29fc3af585113aacb32cb82e483db64808b882113"
    sha256 cellar: :any,                 sonoma:        "e042edc3b1016183017785f7e9a0c4bf8f1826407a6ec43587ba84ab5ef8d870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7f0607c20a91904c6ea1727701ab792dbe1cde10f14638a219497ad62363b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771bedc3169c294ce4ad2e857e8a8635c4fe1c910c6b926dbeb4157d2626d989"
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
