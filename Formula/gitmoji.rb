require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.0.0.tgz"
  sha256 "5cbda2eeab0171bbe33f193a051bfbca2138f05a0293fc9229b31b420e543141"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aaadacadead7d839fc12dadce761d24a9e1bc470d2034f282021440f145c053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aaadacadead7d839fc12dadce761d24a9e1bc470d2034f282021440f145c053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aaadacadead7d839fc12dadce761d24a9e1bc470d2034f282021440f145c053"
    sha256 cellar: :any_skip_relocation, ventura:        "664dbb4d029f8185e50636254fe97cad2d3c3af996aa290374e0b2a7ae9d54ab"
    sha256 cellar: :any_skip_relocation, monterey:       "664dbb4d029f8185e50636254fe97cad2d3c3af996aa290374e0b2a7ae9d54ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "664dbb4d029f8185e50636254fe97cad2d3c3af996aa290374e0b2a7ae9d54ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aaadacadead7d839fc12dadce761d24a9e1bc470d2034f282021440f145c053"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
