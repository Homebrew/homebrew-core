class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.8.0.tgz"
  sha256 "6c242cc853cda7748c850aafdb13df7ec05a4d64dd1badabc87b865fb25d9775"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9ad018a47784ad630908660e7d046667249aeabb44dc626c2cc7d7eba11627a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ad018a47784ad630908660e7d046667249aeabb44dc626c2cc7d7eba11627a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9ad018a47784ad630908660e7d046667249aeabb44dc626c2cc7d7eba11627a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca9b14e39291378f087640fc43df856cc1563902e1dcbcf0c7d58bda9f181c8a"
    sha256 cellar: :any_skip_relocation, ventura:       "ca9b14e39291378f087640fc43df856cc1563902e1dcbcf0c7d58bda9f181c8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c612a2a32afd765251ecec05911ec06cc5e4944492c1a2a1432b68fc46ac0db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9ad018a47784ad630908660e7d046667249aeabb44dc626c2cc7d7eba11627a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end
