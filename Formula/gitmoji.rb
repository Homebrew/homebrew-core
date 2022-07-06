require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.2.tgz"
  sha256 "c104d1e0a1143caaf81caf2cc473e8cd2c736fab68994b3e7af694bd38a4fce7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b61adc16e52fb9574da999f988450c9230ffffbbbf63a15b8c83c2ab269ea2f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b61adc16e52fb9574da999f988450c9230ffffbbbf63a15b8c83c2ab269ea2f9"
    sha256 cellar: :any_skip_relocation, monterey:       "e5dc6f5c52815154ee3bb09a1876829c2a6d515729ca5a83b7dfc4a55020e832"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5dc6f5c52815154ee3bb09a1876829c2a6d515729ca5a83b7dfc4a55020e832"
    sha256 cellar: :any_skip_relocation, catalina:       "e5dc6f5c52815154ee3bb09a1876829c2a6d515729ca5a83b7dfc4a55020e832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b61adc16e52fb9574da999f988450c9230ffffbbbf63a15b8c83c2ab269ea2f9"
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
