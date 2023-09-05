require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-6.3.0.tgz"
  sha256 "133c1b7ce9a9b0f703da7bd0201d0ec4ad49f5f610c9b008da6df2ec30f3f4ba"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6910c3128a0ffdcb7239a1fe6aeb9344e6b6ea8d9a8500291fa5423179ae45f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c8eb3ef1a60934230d70b1195c6bf1d708be8ae1fb7f1922f31d3e8796cf35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8c8eb3ef1a60934230d70b1195c6bf1d708be8ae1fb7f1922f31d3e8796cf35"
    sha256 cellar: :any_skip_relocation, ventura:        "775cdefaaf9057243806ddd222912d35f964340d7f436d3f6437af5dfabf06b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a5daf9b48cf25528279debdd2b1ad37baaa6d08cfd6e18e212a60a68dc3f35ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5daf9b48cf25528279debdd2b1ad37baaa6d08cfd6e18e212a60a68dc3f35ef"
    sha256 cellar: :any_skip_relocation, catalina:       "a5daf9b48cf25528279debdd2b1ad37baaa6d08cfd6e18e212a60a68dc3f35ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e726055fa242838fa081dce26d2ff0441d1aeef2ddd6b5065b04961441d625"
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
