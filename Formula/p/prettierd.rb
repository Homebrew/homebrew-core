class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.25.3.tgz"
  sha256 "39b761c81a6d1d65819ea2f30e96965e25e7ada6d14644e449116e9543b4619f"
  license "ISC"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "09e3ec3d5b7a6e73ccd4dd9478f2c34be67b24dfb0ceb6384bd1831e325a209d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = pipe_output("#{bin}/prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
