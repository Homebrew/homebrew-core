require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.14.25.tgz"
  sha256 "12f1a0a280ecd586d4c5450126ed050a39f32cb0e9f89ce948cd6eddb871af6d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5567c4cb1e1a487f9c23dd97edfe8e69b58066c40c8632a529bf52b193566d9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5567c4cb1e1a487f9c23dd97edfe8e69b58066c40c8632a529bf52b193566d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "aabd011279c0b37a14d7b7b8fb706fdd153042bc944502d67b7f807d885aefab"
    sha256 cellar: :any_skip_relocation, big_sur:        "aabd011279c0b37a14d7b7b8fb706fdd153042bc944502d67b7f807d885aefab"
    sha256 cellar: :any_skip_relocation, catalina:       "aabd011279c0b37a14d7b7b8fb706fdd153042bc944502d67b7f807d885aefab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5567c4cb1e1a487f9c23dd97edfe8e69b58066c40c8632a529bf52b193566d9b"
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
