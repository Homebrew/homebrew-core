class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.5.tgz"
  sha256 "8b796443c0c0afcc3db5d47689ab955bddcab0f1058ef9864f2ea1745582de09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6669fc6efb9d2811bfb454243ffec6f2bbeee3ce63f489a1d1081c4287f77fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6669fc6efb9d2811bfb454243ffec6f2bbeee3ce63f489a1d1081c4287f77fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6669fc6efb9d2811bfb454243ffec6f2bbeee3ce63f489a1d1081c4287f77fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6669fc6efb9d2811bfb454243ffec6f2bbeee3ce63f489a1d1081c4287f77fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6669fc6efb9d2811bfb454243ffec6f2bbeee3ce63f489a1d1081c4287f77fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3469b5245657322e55b198493f6d8f34667c50b5d0778b53fbb9295147c37f77"
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
