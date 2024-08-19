class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.4.tgz"
  sha256 "825089b3b8f4660346c0bc5fc96caa840e55af1bb07a5f7dc1686fdcba35eeb3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39a74a7f2e057c6482fcd6753951cd5afc5ade75dcdd23b03444b39171593b0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a74a7f2e057c6482fcd6753951cd5afc5ade75dcdd23b03444b39171593b0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a74a7f2e057c6482fcd6753951cd5afc5ade75dcdd23b03444b39171593b0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "703353047b69d3c034e7ffb49a69912f8d8962c2cb062c86b4df4b7a43b1da37"
    sha256 cellar: :any_skip_relocation, ventura:        "703353047b69d3c034e7ffb49a69912f8d8962c2cb062c86b4df4b7a43b1da37"
    sha256 cellar: :any_skip_relocation, monterey:       "703353047b69d3c034e7ffb49a69912f8d8962c2cb062c86b4df4b7a43b1da37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39a74a7f2e057c6482fcd6753951cd5afc5ade75dcdd23b03444b39171593b0d"
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
