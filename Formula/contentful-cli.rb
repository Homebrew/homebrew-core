require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.16.5.tgz"
  sha256 "3535ee73d04d03a4b841f636449812ef35e8ca2ce1af27f0dfe624392b8a8099"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2477c09e2b4a328decbcbb1807b3edd63549c2fb96f06b8e344483969a4baeec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2477c09e2b4a328decbcbb1807b3edd63549c2fb96f06b8e344483969a4baeec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2477c09e2b4a328decbcbb1807b3edd63549c2fb96f06b8e344483969a4baeec"
    sha256 cellar: :any_skip_relocation, ventura:        "3dde7d7f38d7681ee0f51a1eb79d2fb2519ebc3672d351399f96f7a5d74e2ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "3dde7d7f38d7681ee0f51a1eb79d2fb2519ebc3672d351399f96f7a5d74e2ffd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dde7d7f38d7681ee0f51a1eb79d2fb2519ebc3672d351399f96f7a5d74e2ffd"
    sha256 cellar: :any_skip_relocation, catalina:       "3dde7d7f38d7681ee0f51a1eb79d2fb2519ebc3672d351399f96f7a5d74e2ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2477c09e2b4a328decbcbb1807b3edd63549c2fb96f06b8e344483969a4baeec"
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
