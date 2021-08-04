require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.3.0.tgz"
  sha256 "6d7cfb2a456df56d39e12d6566380b801a09225827bd155bcfccaedc8f6488c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e7dd51cc407ce71a277243809c7b51611f431b1727dce7fdbbfa5507b7db6dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "ef0120c75025896376d675707f7c22105e6ee010d2f64724321624342fc9611d"
    sha256 cellar: :any_skip_relocation, catalina:      "ef0120c75025896376d675707f7c22105e6ee010d2f64724321624342fc9611d"
    sha256 cellar: :any_skip_relocation, mojave:        "ef0120c75025896376d675707f7c22105e6ee010d2f64724321624342fc9611d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e7dd51cc407ce71a277243809c7b51611f431b1727dce7fdbbfa5507b7db6dc"
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
