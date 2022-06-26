require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-6.2.0.tgz"
  sha256 "d577729d6b0c21cccf7c6e81b395a3bfe2f058f29fca8c569643639f3b571772"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "247799071e0e7e6b2ad7d99c87fa6346e79f86c01d176565373190cdff3b07d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "247799071e0e7e6b2ad7d99c87fa6346e79f86c01d176565373190cdff3b07d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e81819487b36ddb1288988183f7b923aa5c206daf530c64b804b350aec75e08d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e81819487b36ddb1288988183f7b923aa5c206daf530c64b804b350aec75e08d"
    sha256 cellar: :any_skip_relocation, catalina:       "e81819487b36ddb1288988183f7b923aa5c206daf530c64b804b350aec75e08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129c5b4637e726823ce327942b94043e98318ca45eb56d2e3c50814c0edc3806"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end
