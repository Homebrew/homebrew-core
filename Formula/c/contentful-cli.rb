require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.8.27.tgz"
  sha256 "0b7562e9f887bfea5ca5ef8a056c436aa4b4e6ba50a4e4f73d0cdd01dc97e00e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb7158228eb39e51c05f268cc7944743de69fe00fc5631220ebe48f8bdebfab4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb7158228eb39e51c05f268cc7944743de69fe00fc5631220ebe48f8bdebfab4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb7158228eb39e51c05f268cc7944743de69fe00fc5631220ebe48f8bdebfab4"
    sha256 cellar: :any_skip_relocation, sonoma:         "a208ac5c9b1c62f00dff61310cc91c4ad7640eb5242661d18ea01293ec70e23a"
    sha256 cellar: :any_skip_relocation, ventura:        "a208ac5c9b1c62f00dff61310cc91c4ad7640eb5242661d18ea01293ec70e23a"
    sha256 cellar: :any_skip_relocation, monterey:       "a208ac5c9b1c62f00dff61310cc91c4ad7640eb5242661d18ea01293ec70e23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7158228eb39e51c05f268cc7944743de69fe00fc5631220ebe48f8bdebfab4"
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
