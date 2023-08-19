require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.4.0.tgz"
  sha256 "cf42f321756afc8a8eb2dfc93af59e5c16090fab98d5b7bd101e9a0f8434102a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70af19c0e731b24406a88dd0b7f8a07c9e3e757887e5e7930983a984e819235d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70af19c0e731b24406a88dd0b7f8a07c9e3e757887e5e7930983a984e819235d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70af19c0e731b24406a88dd0b7f8a07c9e3e757887e5e7930983a984e819235d"
    sha256 cellar: :any_skip_relocation, ventura:        "de98d0de1d724dc7fa7a5c16ce6f7201c5251d6baff93d17151ec4401555c564"
    sha256 cellar: :any_skip_relocation, monterey:       "de98d0de1d724dc7fa7a5c16ce6f7201c5251d6baff93d17151ec4401555c564"
    sha256 cellar: :any_skip_relocation, big_sur:        "de98d0de1d724dc7fa7a5c16ce6f7201c5251d6baff93d17151ec4401555c564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70af19c0e731b24406a88dd0b7f8a07c9e3e757887e5e7930983a984e819235d"
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
