require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.2.2.tgz"
  sha256 "7d5db8a88ed02ee61bf1611aa1aa59fdde57d2e4feb8cc56c8eb182dfecd5bbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "566582130eff5c5f4392a4b30781c7ae271defe465a4f325e3f8d17d5badcb95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "566582130eff5c5f4392a4b30781c7ae271defe465a4f325e3f8d17d5badcb95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "566582130eff5c5f4392a4b30781c7ae271defe465a4f325e3f8d17d5badcb95"
    sha256 cellar: :any_skip_relocation, ventura:        "e1c59b3faf421f387348ebbbc662b95df5f8a83728ac3c360dc341aa762a0e86"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c59b3faf421f387348ebbbc662b95df5f8a83728ac3c360dc341aa762a0e86"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1c59b3faf421f387348ebbbc662b95df5f8a83728ac3c360dc341aa762a0e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "566582130eff5c5f4392a4b30781c7ae271defe465a4f325e3f8d17d5badcb95"
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
