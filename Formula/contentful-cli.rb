require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.9.45.tgz"
  sha256 "10b288480074e7d1f1370cd731f7fb63236c8acc62e373e65b693b23701adb0b"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4294269d8d3d663886b118ad03698a404b9696ea88df54e92112b3b3afd1c8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4294269d8d3d663886b118ad03698a404b9696ea88df54e92112b3b3afd1c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "43cfd75d24c5cae2e1aab7fec3220b63939fc47a6b2e79546f39bb15a83d9c43"
    sha256 cellar: :any_skip_relocation, big_sur:        "43cfd75d24c5cae2e1aab7fec3220b63939fc47a6b2e79546f39bb15a83d9c43"
    sha256 cellar: :any_skip_relocation, catalina:       "43cfd75d24c5cae2e1aab7fec3220b63939fc47a6b2e79546f39bb15a83d9c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "921639adaf7de0f81066db902e7aff8111d5a36b3816312709b5736811aa6e02"
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
