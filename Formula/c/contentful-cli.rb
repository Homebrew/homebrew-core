class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.6.2.tgz"
  sha256 "038f873b95f9b85bc3a4f2bd06999f2323725f3242f21ea2fee56da5d5588231"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "957dbc35f58672b35cc5e441502a9fa7d2ab59dbec04669e0ad2cac783b95dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "957dbc35f58672b35cc5e441502a9fa7d2ab59dbec04669e0ad2cac783b95dc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "957dbc35f58672b35cc5e441502a9fa7d2ab59dbec04669e0ad2cac783b95dc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9654fc226c849587feae0162543d869ebe36589be52fc31a0ee79d23735325be"
    sha256 cellar: :any_skip_relocation, ventura:       "9654fc226c849587feae0162543d869ebe36589be52fc31a0ee79d23735325be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61434d0dd5a4b8c990c612f8d3a5377c2ab336d445d031d7d91168f4e14dfa8f"
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
