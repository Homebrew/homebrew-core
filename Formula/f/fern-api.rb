class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.9.0.tgz"
  sha256 "ff8a97014671f6a7a4c6976aeed301141c186c243725cacb18551c6729f9e0f8"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f0a85c0714a7705cbff3a2a5b301a7bda2f24a4f3cd8d37bff629e840d0865a"
    sha256 cellar: :any,                 arm64_sequoia: "894be2b5baae7f839554f88bb29d4f29a6eea21ecdecfb1803d361b368b53b3d"
    sha256 cellar: :any,                 arm64_sonoma:  "894be2b5baae7f839554f88bb29d4f29a6eea21ecdecfb1803d361b368b53b3d"
    sha256 cellar: :any,                 sonoma:        "6b8355ac0ab6e43280a35eb4c082899feba786dfb2e4cee813c8a54300f6b17d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92ef469b862db74ecf499dcecbe3b50d4be6d0b7f66a2be4e0df823d8fb89c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47181235b928d68c0e5f21b1bb1066fea5735c746093c02692aa49cf59c972a3"
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
