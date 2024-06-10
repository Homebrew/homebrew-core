require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.4.tgz"
  sha256 "971a3b4750dc65a929970ccb16efd1df2e5a3559f9439e4f6f09a8287542d41f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "88a1737f54350273609968b57e70980d64f728d203f0cf0c1afc212a460156f8"
    sha256 cellar: :any,                 arm64_ventura:  "88a1737f54350273609968b57e70980d64f728d203f0cf0c1afc212a460156f8"
    sha256 cellar: :any,                 arm64_monterey: "88a1737f54350273609968b57e70980d64f728d203f0cf0c1afc212a460156f8"
    sha256 cellar: :any,                 sonoma:         "ce35e61a0cbbf92752de65c5d3782795df43b2aed9986d693fbac9ffed8104b4"
    sha256 cellar: :any,                 ventura:        "ce35e61a0cbbf92752de65c5d3782795df43b2aed9986d693fbac9ffed8104b4"
    sha256 cellar: :any,                 monterey:       "ce35e61a0cbbf92752de65c5d3782795df43b2aed9986d693fbac9ffed8104b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499987c235515d519558bc54342f8cd64cd3536297bbcd34e88fafafde9b98dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
