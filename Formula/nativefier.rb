require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-46.0.4.tgz"
  sha256 "35b85a8b967135d8599c49721ded147c1550feb0ccef239b37f7d79b154b5262"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3321ad919e07700a02740be74f5835907a20b3f52ddb3a736fe99a837478a1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3321ad919e07700a02740be74f5835907a20b3f52ddb3a736fe99a837478a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "9235485ebb4a3f17bec9285516618e7292817592d639640829ded1fbcdaeda55"
    sha256 cellar: :any_skip_relocation, big_sur:        "9235485ebb4a3f17bec9285516618e7292817592d639640829ded1fbcdaeda55"
    sha256 cellar: :any_skip_relocation, catalina:       "9235485ebb4a3f17bec9285516618e7292817592d639640829ded1fbcdaeda55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3321ad919e07700a02740be74f5835907a20b3f52ddb3a736fe99a837478a1b"
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
