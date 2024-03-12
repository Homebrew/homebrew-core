require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.1.0.tgz"
  sha256 "31488ca805d13b23e50bc611d4dd268f88473699bd4e5c5bd59873d2d2f69175"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71c84f8f621bc0b26de53dbcf0d5efd6e4d06c38b446a14039c6ca486216bbaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71c84f8f621bc0b26de53dbcf0d5efd6e4d06c38b446a14039c6ca486216bbaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c84f8f621bc0b26de53dbcf0d5efd6e4d06c38b446a14039c6ca486216bbaf"
    sha256 cellar: :any_skip_relocation, sonoma:         "86badaf4d66dc5c2958cec1f4b99926d2ddb4793a04c8a5aae522564a06f831b"
    sha256 cellar: :any_skip_relocation, ventura:        "86badaf4d66dc5c2958cec1f4b99926d2ddb4793a04c8a5aae522564a06f831b"
    sha256 cellar: :any_skip_relocation, monterey:       "86badaf4d66dc5c2958cec1f4b99926d2ddb4793a04c8a5aae522564a06f831b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c84f8f621bc0b26de53dbcf0d5efd6e4d06c38b446a14039c6ca486216bbaf"
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
