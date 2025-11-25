class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.4.tgz"
  sha256 "44b9dd874c19b8ff194275b93d55e54813fcf9695c10c7a21acd4db6f56d232c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57b923ef957bdedbfcd2d27a3a8422a4dd85123d555258ca2d3c87fa76af1975"
    sha256 cellar: :any,                 arm64_sequoia: "eea8d41a87d4ab89ee073e8eb58921f07167c75f9df71a433e9689fca99df279"
    sha256 cellar: :any,                 arm64_sonoma:  "eea8d41a87d4ab89ee073e8eb58921f07167c75f9df71a433e9689fca99df279"
    sha256 cellar: :any,                 sonoma:        "d87729e633df46930a05050e1a7cd2115d0a58f15a9e213bdb4a369c0c871080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63eca7d6856de83ab087c28ce01ba37eb76e69bc4b147f887d552df793d611ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb56f08f35bf86242f78769a51abf34fbf7583c4979833e68be00cc6e6c15fbb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end
