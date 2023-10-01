require "language/node"

class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.25.1.tgz"
  sha256 "9b19f11c6b099c518fc8d4c0b6da697c8e15796fb2bb4ab689737f084d29ac3f"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f2b9045f60539c715079e26b01313e78eac5e433f7c4e559b072c54ac91c578"
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
