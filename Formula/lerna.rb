require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.19.0.tgz"
  sha256 "2ba203b98189abab6902e246a267be5952d7c4d273b984b0e3152e97e5db1c9c"

  bottle do
    cellar :any_skip_relocation
    sha256 "fef3db1bb1cd935371419bab50eb9b89ee40b1b403f0f66097851a6057927fde" => :catalina
    sha256 "d6f78e8f7a2ad8c1df8a8b410cc175e34d264177f6527fa3076a726a4017810b" => :mojave
    sha256 "55453f8bfe34662479e608861c440bc041b5d2c086064b28d0d9dd2767e3b580" => :high_sierra
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
