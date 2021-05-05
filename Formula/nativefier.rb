require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-43.1.2.tgz"
  sha256 "f8681c081f41a71f9c1a089e24f0f97151888a0f5e1783af1e013a1ec99ac5e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce5349ed8f467b249e53add1e39a9e910e4768a46608b71651151d849b7eab21"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d57c70de50b7800947733d11ff33083f1e86cf85df000c203b29ed0a63ee7f7"
    sha256 cellar: :any_skip_relocation, catalina:      "3d57c70de50b7800947733d11ff33083f1e86cf85df000c203b29ed0a63ee7f7"
    sha256 cellar: :any_skip_relocation, mojave:        "3d57c70de50b7800947733d11ff33083f1e86cf85df000c203b29ed0a63ee7f7"
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
