require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-47.0.0.tgz"
  sha256 "dae80b4d83fe3a3dc9a1a9260d121882e1beca14ff9a4f3154836540c759311e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d51bdc76e1b23813628d653667235230aae14b6e00361fb7a8b8f9b8510ace4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d51bdc76e1b23813628d653667235230aae14b6e00361fb7a8b8f9b8510ace4"
    sha256 cellar: :any_skip_relocation, monterey:       "fae6bdb6b6afd940f10e8cf1260ba138d68b5be69334ded18d2a1e9eb602e6a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae6bdb6b6afd940f10e8cf1260ba138d68b5be69334ded18d2a1e9eb602e6a0"
    sha256 cellar: :any_skip_relocation, catalina:       "fae6bdb6b6afd940f10e8cf1260ba138d68b5be69334ded18d2a1e9eb602e6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d51bdc76e1b23813628d653667235230aae14b6e00361fb7a8b8f9b8510ace4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
