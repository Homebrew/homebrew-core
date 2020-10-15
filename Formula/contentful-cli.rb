require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.39.tgz"
  sha256 "ad34f8ed9aadcb8208cb10182e7e4f6f0253ca91186221d9695deeceac99b597"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2b958bc72074edda0ad1141f77c4a34efef9dba6fb2b59be942e3f7c37429b81" => :catalina
    sha256 "f08e41ecaecd3471dc0a3da8f73dc0ddb3b835d3762d813dfda0bcb0c2632c5d" => :mojave
    sha256 "c8b6ac933617f6c862d0ea05a1eda532b7b4a974aaa91e8c1a5091749201f569" => :high_sierra
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
