require "language/node"

class ChalkCli < Formula
  desc "Terminal string styling done right"
  homepage "https://github.com/chalk/chalk-cli"
  url "https://registry.npmjs.org/chalk-cli/-/chalk-cli-5.0.1.tgz"
  sha256 "17befe5108e2fd64661305b4f1d7378dfdb2f34ae4e1bba6d895ff427b7b4286"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36202571cae4f3cf1dfdf4b03739e501beef3c46ec3dc76a1df41f831ebcd0aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hello, world!", pipe_output("#{bin}/chalk bold cyan --stdin", "hello, world!")
  end
end
