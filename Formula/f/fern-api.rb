class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.122.0.tgz"
  sha256 "075e771407571fba2d42627469285df99bf0a7aad272167cd1085336fbf0269c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5bc141baadedd60dc8f7d90d0e48eff67ff776c745307254d84e7b8139b885ea"
    sha256 cellar: :any,                 arm64_tahoe:       "5bc141baadedd60dc8f7d90d0e48eff67ff776c745307254d84e7b8139b885ea"
    sha256 cellar: :any,                 arm64_sequoia:     "5bc141baadedd60dc8f7d90d0e48eff67ff776c745307254d84e7b8139b885ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e76b13ecd4dc00a6456ca9b3560217d5c4ef39fe7b948026f4f968a65afcaffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4b13596b30fcffb46082c4702c27ca2a6c0944f4177e681eaa9847e993ed0165"
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
