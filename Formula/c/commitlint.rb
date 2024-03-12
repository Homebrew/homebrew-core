require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.1.0.tgz"
  sha256 "31488ca805d13b23e50bc611d4dd268f88473699bd4e5c5bd59873d2d2f69175"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee0b7847f86f09df48461ead6ac72d29861c8a5acadf032bd5b807cf4e0dfd94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee0b7847f86f09df48461ead6ac72d29861c8a5acadf032bd5b807cf4e0dfd94"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0b7847f86f09df48461ead6ac72d29861c8a5acadf032bd5b807cf4e0dfd94"
    sha256 cellar: :any_skip_relocation, sonoma:         "91dfe41b5009fd1b6b2dc2588e339d228765b8e71a5e2bfb64f9586e9f3d865d"
    sha256 cellar: :any_skip_relocation, ventura:        "91dfe41b5009fd1b6b2dc2588e339d228765b8e71a5e2bfb64f9586e9f3d865d"
    sha256 cellar: :any_skip_relocation, monterey:       "91dfe41b5009fd1b6b2dc2588e339d228765b8e71a5e2bfb64f9586e9f3d865d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee0b7847f86f09df48461ead6ac72d29861c8a5acadf032bd5b807cf4e0dfd94"
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
