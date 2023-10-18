require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.8.0.tgz"
  sha256 "873388df711d98413d760adacefd7230a2f0894a425b6d10f93ec2fa7084cab5"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd64684103f7e3360669584cb6c3a138c7be9f429a8043e145d68a1829a945a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd64684103f7e3360669584cb6c3a138c7be9f429a8043e145d68a1829a945a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd64684103f7e3360669584cb6c3a138c7be9f429a8043e145d68a1829a945a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "50381721bfbf23d0161c68fbe168ba642fc13b119b19211c5c24cd7f7f407a59"
    sha256 cellar: :any_skip_relocation, ventura:        "50381721bfbf23d0161c68fbe168ba642fc13b119b19211c5c24cd7f7f407a59"
    sha256 cellar: :any_skip_relocation, monterey:       "50381721bfbf23d0161c68fbe168ba642fc13b119b19211c5c24cd7f7f407a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd64684103f7e3360669584cb6c3a138c7be9f429a8043e145d68a1829a945a1"
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
