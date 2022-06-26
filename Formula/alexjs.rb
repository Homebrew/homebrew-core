require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/10.0.0.tar.gz"
  sha256 "2498ce4818463c6191e7120040426a8e8e883ea4b97b632907483e21e3494d2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7ee77cee577f024ebae4e2a14d86fc0d20ae844acc4fe706f488de9ae2c240f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "970a9f5d0d22e0934ebe287c7d64c0e79a745a139dcbaf7ce6e643ee84184b43"
    sha256 cellar: :any_skip_relocation, monterey:       "b89880688913298cb886a915f9a0756ba92f1c6570a87c4859496beb3d4f66bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "a616902bfd0d0d1205eca973d30ad3657246e2d88dff8a6f5c7e98c70375b60d"
    sha256 cellar: :any_skip_relocation, catalina:       "a616902bfd0d0d1205eca973d30ad3657246e2d88dff8a6f5c7e98c70375b60d"
    sha256 cellar: :any_skip_relocation, mojave:         "a616902bfd0d0d1205eca973d30ad3657246e2d88dff8a6f5c7e98c70375b60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "970a9f5d0d22e0934ebe287c7d64c0e79a745a139dcbaf7ce6e643ee84184b43"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
