require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-18.6.1.tgz"
  sha256 "2bd7739a64cfbd671c4c014d44ed479f3fea5124fc4d1629e083a1ddabf0aef4"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c73b06653360fbe44d1d270ccf76df4b89906006b1ce20134265f85f327a56b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73b06653360fbe44d1d270ccf76df4b89906006b1ce20134265f85f327a56b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c73b06653360fbe44d1d270ccf76df4b89906006b1ce20134265f85f327a56b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9091bea42766e4f246c593afab8bd00ca443fc966fb5c47b6b461a52b243067a"
    sha256 cellar: :any_skip_relocation, ventura:        "9091bea42766e4f246c593afab8bd00ca443fc966fb5c47b6b461a52b243067a"
    sha256 cellar: :any_skip_relocation, monterey:       "9091bea42766e4f246c593afab8bd00ca443fc966fb5c47b6b461a52b243067a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c73b06653360fbe44d1d270ccf76df4b89906006b1ce20134265f85f327a56b8"
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
