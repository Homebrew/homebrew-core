require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.8.tgz"
  sha256 "3c9c3052acb605e6c6d7a11bc4f1f2b899f3900dbb511b8774b1c7af41c03908"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31e2c4b5f9949bc1c7410318136e7d5c36401eec28afd1cbd475029ef20f1e31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31e2c4b5f9949bc1c7410318136e7d5c36401eec28afd1cbd475029ef20f1e31"
    sha256 cellar: :any_skip_relocation, monterey:       "4e35474f897b267d999eabc48b73eb94aecb60a7bf90de201d63a0c3ac885b89"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a874ce77d64b9e897de83796b89e48c757dd24d2ede98b78e7dda69867fe37f"
    sha256 cellar: :any_skip_relocation, catalina:       "9a874ce77d64b9e897de83796b89e48c757dd24d2ede98b78e7dda69867fe37f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31e2c4b5f9949bc1c7410318136e7d5c36401eec28afd1cbd475029ef20f1e31"
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
