require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.11.0.tgz"
  sha256 "314885f2c9437846f37c1c771618d2fc42a7e7f44e384591baa54265eeb4a689"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfd5d989f802111939cbc30e35750a6ed11b8d3d14e0349f9502926edc038837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfd5d989f802111939cbc30e35750a6ed11b8d3d14e0349f9502926edc038837"
    sha256 cellar: :any_skip_relocation, monterey:       "c9d8b1a2f5f9a381e06d939791f8ab154a29343a28fbe9c80948540c8ba611e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9d8b1a2f5f9a381e06d939791f8ab154a29343a28fbe9c80948540c8ba611e5"
    sha256 cellar: :any_skip_relocation, catalina:       "c9d8b1a2f5f9a381e06d939791f8ab154a29343a28fbe9c80948540c8ba611e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfd5d989f802111939cbc30e35750a6ed11b8d3d14e0349f9502926edc038837"
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
