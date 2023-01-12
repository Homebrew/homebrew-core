require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.4.2.tgz"
  sha256 "ea49922620b6a5b8dbb3a4695d11cad76fa8968157ee83464d5fd6c33e8b84a0"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58bf6114713a31b164731a6de2db908f897a9c27de0ca8b67c888dfc52ca9a19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58bf6114713a31b164731a6de2db908f897a9c27de0ca8b67c888dfc52ca9a19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58bf6114713a31b164731a6de2db908f897a9c27de0ca8b67c888dfc52ca9a19"
    sha256 cellar: :any_skip_relocation, ventura:        "2e7c741c5d7b39fa5916929d1ec46c143d87342da1e8d70b3101708262bbac0d"
    sha256 cellar: :any_skip_relocation, monterey:       "2e7c741c5d7b39fa5916929d1ec46c143d87342da1e8d70b3101708262bbac0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e7c741c5d7b39fa5916929d1ec46c143d87342da1e8d70b3101708262bbac0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58bf6114713a31b164731a6de2db908f897a9c27de0ca8b67c888dfc52ca9a19"
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
