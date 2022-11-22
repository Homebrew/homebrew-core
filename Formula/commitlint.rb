require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.3.0.tgz"
  sha256 "37ebb051e3600e731fc3be3cf3b84b4fa88d8003d8b8c99dffa7dc4ea927c37e"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "538e8f5fe80de3d505512730e86d34d9d14085f6d9547d3bda0eaba66f25b936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "538e8f5fe80de3d505512730e86d34d9d14085f6d9547d3bda0eaba66f25b936"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "538e8f5fe80de3d505512730e86d34d9d14085f6d9547d3bda0eaba66f25b936"
    sha256 cellar: :any_skip_relocation, monterey:       "cb35ed4534d4f33f632d3a2def192949c1de75740af3f757040554274f19539a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb35ed4534d4f33f632d3a2def192949c1de75740af3f757040554274f19539a"
    sha256 cellar: :any_skip_relocation, catalina:       "cb35ed4534d4f33f632d3a2def192949c1de75740af3f757040554274f19539a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "538e8f5fe80de3d505512730e86d34d9d14085f6d9547d3bda0eaba66f25b936"
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
