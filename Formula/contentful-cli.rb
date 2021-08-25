require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.0.tgz"
  sha256 "f188976031405b66696891c07fe4dea6a1ced2fdd6a38a3932e1571aeba96305"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b8e8cab4fb826fe58732f21082c673ad9b5d3894e9e1f51a1a9a97a24f40a12e"
    sha256 cellar: :any_skip_relocation, big_sur:       "38461ee0f77a4dd7374cd6e7ddece82dd5b5d7a7774b0d04bef9e51422141424"
    sha256 cellar: :any_skip_relocation, catalina:      "38461ee0f77a4dd7374cd6e7ddece82dd5b5d7a7774b0d04bef9e51422141424"
    sha256 cellar: :any_skip_relocation, mojave:        "38461ee0f77a4dd7374cd6e7ddece82dd5b5d7a7774b0d04bef9e51422141424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6632723c4e0898bbb6e3987409166840c16634367f7e171131b4e76ce0e62fdd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
