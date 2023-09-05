require "language/node"

class Prettierd < Formula
  desc "Prettier daemon"
  homepage "https://github.com/fsouza/prettierd"
  url "https://registry.npmjs.org/@fsouza/prettierd/-/prettierd-0.24.2.tgz"
  sha256 "1dfe44ebfad78799fcaf477cd9fdb74be4095b1646433de2b13f490498106670"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3a1de65c229f2439c2bf07971d8b73a932c6cd275f293a7406f56cbfe799637"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3a1de65c229f2439c2bf07971d8b73a932c6cd275f293a7406f56cbfe799637"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3a1de65c229f2439c2bf07971d8b73a932c6cd275f293a7406f56cbfe799637"
    sha256 cellar: :any_skip_relocation, ventura:        "e3a1de65c229f2439c2bf07971d8b73a932c6cd275f293a7406f56cbfe799637"
    sha256 cellar: :any_skip_relocation, monterey:       "e3a1de65c229f2439c2bf07971d8b73a932c6cd275f293a7406f56cbfe799637"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3a1de65c229f2439c2bf07971d8b73a932c6cd275f293a7406f56cbfe799637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57feb7a5c0c9bb1581c07c1c1efbf3d1342735184389f8f92d77057709b53379"
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
