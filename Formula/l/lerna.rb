class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-9.0.4.tgz"
  sha256 "efcae3f5b765eb8444dfb65bd4573262ce080fd35bb95999b6d072cf76912fcb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "88a7704dae72ba87fb4003212f6a9868170bbe9a16159fa3e663c3fef8442381"
    sha256 cellar: :any,                 arm64_sequoia: "2371c0b57c66520b66fbd695f52bb7c07d5e73f61c07a23d746ff5b94f34cd91"
    sha256 cellar: :any,                 arm64_sonoma:  "2371c0b57c66520b66fbd695f52bb7c07d5e73f61c07a23d746ff5b94f34cd91"
    sha256 cellar: :any,                 sonoma:        "184093aef13d64429ffe160766de778b4f2c7a1a8e69feda1ec0023fdd60e9f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5d09bd0a599c6a18155f541e8b62e9338c2d8d496e98884eb4c8ad0755ab03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf4e44c5a052951bff0ab2be478195053ba98c275524f857ae5c05600199a6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
