require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-4.0.0.tgz"
  sha256 "64330ffdb7b7d879e40ca2520028958b9d6daff34a32547ced138b5896633bd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26197d377f65b4ad2b0d609e03a56a7dafb931f122942413b91b09afb40fbb2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e7264f3be53a6d765ed2578342a1e7909d39a99fb28ba431928fdfec6cd2955"
    sha256 cellar: :any_skip_relocation, monterey:       "0383bd025ddd6bb1a54d8e86977acf3faec11760a5af63bd4a48372e64b6e3ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "53885b6ebfeae441afa66d521667427dea0c4188f4ffb1cfe64e29639987d4a9"
    sha256 cellar: :any_skip_relocation, catalina:       "67e710cabaa7060f1ef2cf6cbafc8734daa93c4c21889a381b7551218e205b34"
    sha256 cellar: :any_skip_relocation, mojave:         "e32988735ca0475d93000c7a2d163289da595263c1d6d416321f9f84f1ce5f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b25304b9c54048c19afaf5ed6fd8fa5aae525b5bb2d58abe939f5ae5ba3f891c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
