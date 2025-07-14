class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.8.1.tgz"
  sha256 "b87082a3113be1c2929db63d727d3765b92f89e103b966996e7cfc560315ef68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5060996ad29bdfaed43cc556cd7f361c3fb3fb4240fe0f8ed9b3e2634963ec9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5060996ad29bdfaed43cc556cd7f361c3fb3fb4240fe0f8ed9b3e2634963ec9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5060996ad29bdfaed43cc556cd7f361c3fb3fb4240fe0f8ed9b3e2634963ec9"
    sha256 cellar: :any_skip_relocation, sonoma:        "86842a5c386c604d290b3784bfc29310ee7bc4de1e6b3c71d5a4621947d8b35d"
    sha256 cellar: :any_skip_relocation, ventura:       "86842a5c386c604d290b3784bfc29310ee7bc4de1e6b3c71d5a4621947d8b35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5060996ad29bdfaed43cc556cd7f361c3fb3fb4240fe0f8ed9b3e2634963ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5060996ad29bdfaed43cc556cd7f361c3fb3fb4240fe0f8ed9b3e2634963ec9"
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
