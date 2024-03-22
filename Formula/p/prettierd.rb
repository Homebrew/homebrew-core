require "language/node"

class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.25.2.tgz"
  sha256 "f1a8befeaa214039ecc264c1b0d13e731145eab3ad7739cf0a93a3b0f93d6ce0"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84210b17dae241e1d884038d8259f51544b5cd45c40982bd64d38ea20756e5d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = pipe_output("#{bin}/prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
