require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.18.tgz"
  sha256 "c4db0d01e8bb7b62cf424d6b2d9fd70225bc5ebc9111b2feaf274b64d6db3884"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b81b993db235de8580a935925a0b543f048637a2ae0e52df101f8a8a9aeddf0"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa481b2d3232b52e38672d5d4a63b3554d5485b4c8a68a2bd708112e43cd1b17"
    sha256 cellar: :any_skip_relocation, catalina:      "7d661b3b3f3f14b74921b64bd11509baf1588f2b9e11b3fd95c0baf76a615642"
    sha256 cellar: :any_skip_relocation, mojave:        "03693aa7bce8b924a125f27ae3e4b18407737b1a0e1e6e7bc76b1da8d497ac10"
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
