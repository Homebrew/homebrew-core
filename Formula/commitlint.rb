require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.4.4.tgz"
  sha256 "b209ea55b4714de922fe765d8f7842f023ecdea942c3164cf290a839803776bd"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e218169531e54b028d1538d5a48b0f07de328c2482916bd5051cb55a11a17647"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e218169531e54b028d1538d5a48b0f07de328c2482916bd5051cb55a11a17647"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e218169531e54b028d1538d5a48b0f07de328c2482916bd5051cb55a11a17647"
    sha256 cellar: :any_skip_relocation, ventura:        "b329705ff7836ff69ecb988e36959d2d62c95419526375fcb1dc2f0e2e82def6"
    sha256 cellar: :any_skip_relocation, monterey:       "b329705ff7836ff69ecb988e36959d2d62c95419526375fcb1dc2f0e2e82def6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b329705ff7836ff69ecb988e36959d2d62c95419526375fcb1dc2f0e2e82def6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e218169531e54b028d1538d5a48b0f07de328c2482916bd5051cb55a11a17647"
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
