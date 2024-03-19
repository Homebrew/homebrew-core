require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.2.1.tgz"
  sha256 "680a6a30a95eb2dcacfe9c7916d7ed604c678fcfcbb366f9970edb32e4b1348f"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e40cd8d6d2c8f62bec77f91ed121d0a8f212b6eccb4dc50089244017b4409bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e40cd8d6d2c8f62bec77f91ed121d0a8f212b6eccb4dc50089244017b4409bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e40cd8d6d2c8f62bec77f91ed121d0a8f212b6eccb4dc50089244017b4409bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "327fd92e55c9bf8ee770dcc178a2bfa25f3ac7e35e2d8ead3f94b0093a3c70ef"
    sha256 cellar: :any_skip_relocation, ventura:        "327fd92e55c9bf8ee770dcc178a2bfa25f3ac7e35e2d8ead3f94b0093a3c70ef"
    sha256 cellar: :any_skip_relocation, monterey:       "327fd92e55c9bf8ee770dcc178a2bfa25f3ac7e35e2d8ead3f94b0093a3c70ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e40cd8d6d2c8f62bec77f91ed121d0a8f212b6eccb4dc50089244017b4409bf"
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
