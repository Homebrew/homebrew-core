class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.5.tgz"
  sha256 "8b796443c0c0afcc3db5d47689ab955bddcab0f1058ef9864f2ea1745582de09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb3e32389738beaf73214e2def47ec5d30459695a494c9ed975ae429bcb87da2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb3e32389738beaf73214e2def47ec5d30459695a494c9ed975ae429bcb87da2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3e32389738beaf73214e2def47ec5d30459695a494c9ed975ae429bcb87da2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb3e32389738beaf73214e2def47ec5d30459695a494c9ed975ae429bcb87da2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb3e32389738beaf73214e2def47ec5d30459695a494c9ed975ae429bcb87da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14802200aa5b9f40840fb9996115de9b2f6a8b23a9f92ea515338828ad3ddf2a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
