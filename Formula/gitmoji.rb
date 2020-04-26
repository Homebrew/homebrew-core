require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.4.tgz"
  sha256 "40c570d12125cde7158ece8cdfa5159885ceb284b093faa1ea140cfdd3db70d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea1470d274a41507c505bb100ff11a15293743e3433f968f6a29eb8fea4264f1" => :catalina
    sha256 "11180e0e4e5cad16fa656aef59b6b05f202ff586cb526daf986b01e5e79c8926" => :mojave
    sha256 "c7c4039eba4f1bb9966e676c34a12b1079b0aa2c8cdadb3917b84079f18aad16" => :high_sierra
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
