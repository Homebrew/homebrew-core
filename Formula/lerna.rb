require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.22.1.tgz"
  sha256 "77a036b03fafd7a6915ef32ad9e0f5cb1950ae8c86ee27fa886e2e1bad4004ac"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c83c1729e22b25ee574dd777aeafa6609354b28677a84edb4871c6316ec695a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "0284f238fa3b15213745e9b41112bba211478c88c6912a8cc5cdaddae626f5ea"
    sha256 cellar: :any_skip_relocation, catalina:      "5f2b51b458e4379c8f4bf192eb532e567fa2a209eff59fc78aa4a73a2c95c9a4"
    sha256 cellar: :any_skip_relocation, mojave:        "363088564849de9b6c79ac5cdbbb872ca43841b0d80af27c85c696cbd2dc75bb"
    sha256 cellar: :any_skip_relocation, high_sierra:   "833823b45ebd250a74b170f980861ae9cc6831040e5362309e637d13291a97af"
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
