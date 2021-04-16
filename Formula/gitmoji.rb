require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.3.1.tgz"
  sha256 "bad0abd6e2bd50438fbf55aa915e8a8e1e2b817d8af2462d78496bd531dbebad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3ca278e22c25989bb4b8194f42bd6b12f6872020b90574ea6b8c8a3875b14bcb"
    sha256 cellar: :any_skip_relocation, big_sur:       "466531cc020fb626b1c1fe1664d96b5aa3f76f0af10fbba951cbc09844720755"
    sha256 cellar: :any_skip_relocation, catalina:      "37ef99b231c9495b54e582d2e75892f529bb8095db68f624879e18c94d2834b1"
    sha256 cellar: :any_skip_relocation, mojave:        "b64740102a61beb2682a87b9adeaece422f47cc4a4b5b5967c90abbeb810664f"
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
