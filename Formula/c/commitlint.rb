class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.5.0.tgz"
  sha256 "311d285f00d94f0abbfa8bcd7e22201ee97b9212730903ebc3d1f2ab210518b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4182636d19960edad5ce722801cfac2a6b48128c2c8f7a5cecf7e8653665d48d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
