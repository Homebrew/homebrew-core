class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.9.1.tgz"
  sha256 "b057405ded527e3820519d765c8645e2674dd0df493add0d7032cb93e83fb94f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a38054dfc129c435ae196fdf301ff0a9ed9fcc5340f74a684e146d7a7bbd633"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a38054dfc129c435ae196fdf301ff0a9ed9fcc5340f74a684e146d7a7bbd633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a38054dfc129c435ae196fdf301ff0a9ed9fcc5340f74a684e146d7a7bbd633"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a38054dfc129c435ae196fdf301ff0a9ed9fcc5340f74a684e146d7a7bbd633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a38054dfc129c435ae196fdf301ff0a9ed9fcc5340f74a684e146d7a7bbd633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c8cf39337f9d6aa90da5b89183d5c47d16355de13990ce2af47613119d5138"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
