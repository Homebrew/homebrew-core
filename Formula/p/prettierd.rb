class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.28.0.tgz"
  sha256 "944799736015578fdff5ba50dcf200eb052bec3cddfaf922c938867962d6b04a"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae45a9aa88afbb9654eaf651d337cee93ef528467157b845161835a64ca4b30c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = pipe_output("#{bin}/prettierd test.js", "const arr = [1,2];", 0)
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
