require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.4.1.tgz"
  sha256 "29735357c42dc0f84413704f1a70a823f1fed21cf594d6325a83f945ba21a692"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d45347c821ed31c21a5ac760f0e06fd0c5437e00ec09eb9658f3e4d2be407c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d45347c821ed31c21a5ac760f0e06fd0c5437e00ec09eb9658f3e4d2be407c65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d45347c821ed31c21a5ac760f0e06fd0c5437e00ec09eb9658f3e4d2be407c65"
    sha256 cellar: :any_skip_relocation, ventura:        "3113eac87b053b9ca914bfe792d88de36f3d4e12d13dbda43bb9571161e79b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "3113eac87b053b9ca914bfe792d88de36f3d4e12d13dbda43bb9571161e79b1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3113eac87b053b9ca914bfe792d88de36f3d4e12d13dbda43bb9571161e79b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d45347c821ed31c21a5ac760f0e06fd0c5437e00ec09eb9658f3e4d2be407c65"
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
