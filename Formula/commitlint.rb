require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.4.2.tgz"
  sha256 "ea49922620b6a5b8dbb3a4695d11cad76fa8968157ee83464d5fd6c33e8b84a0"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b48861fdb6b8c1eabc515720dbc2eb959f697215623f05624e825027df04b433"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b48861fdb6b8c1eabc515720dbc2eb959f697215623f05624e825027df04b433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b48861fdb6b8c1eabc515720dbc2eb959f697215623f05624e825027df04b433"
    sha256 cellar: :any_skip_relocation, ventura:        "e55d398f6414d09b0a28436583487aa2939ee2a37946e091bd097231100a4426"
    sha256 cellar: :any_skip_relocation, monterey:       "e55d398f6414d09b0a28436583487aa2939ee2a37946e091bd097231100a4426"
    sha256 cellar: :any_skip_relocation, big_sur:        "e55d398f6414d09b0a28436583487aa2939ee2a37946e091bd097231100a4426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48861fdb6b8c1eabc515720dbc2eb959f697215623f05624e825027df04b433"
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
