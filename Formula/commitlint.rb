require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.6.1.tgz"
  sha256 "d68e1178e2e5087071e34011c6ef3076079e7046a41f8116c7ed5ba48dd5fe43"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cf113c7bfb77930ca7a6e0883c62221352ec6444e3226d83a3492a8bdbdcaf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cf113c7bfb77930ca7a6e0883c62221352ec6444e3226d83a3492a8bdbdcaf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cf113c7bfb77930ca7a6e0883c62221352ec6444e3226d83a3492a8bdbdcaf8"
    sha256 cellar: :any_skip_relocation, ventura:        "d2c89379c2ba91805084cae99a44344620ef4a43936f50dc0e85b1dc577070a7"
    sha256 cellar: :any_skip_relocation, monterey:       "d2c89379c2ba91805084cae99a44344620ef4a43936f50dc0e85b1dc577070a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2c89379c2ba91805084cae99a44344620ef4a43936f50dc0e85b1dc577070a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf113c7bfb77930ca7a6e0883c62221352ec6444e3226d83a3492a8bdbdcaf8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end
