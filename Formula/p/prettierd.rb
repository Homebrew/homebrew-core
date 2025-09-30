class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.26.2.tgz"
  sha256 "452b29cb958b4f5623ad06e8f3bf54ca16f6b668bfface1ee023c5278166fc42"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b11cac5d3d092efcc70afca7557edeae6af57e55a6be059585ba50ff6f423a5b"
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
