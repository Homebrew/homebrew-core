class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.1.0.tgz"
  sha256 "d8872521d20a82e70e97afc4f46624d6a1d422b07830f32f80c14354805fd20a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b1c7eaddcc640fe4440ef0c07ed9afb1b88dcd0c87593ca487fce4a355fd920"
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
