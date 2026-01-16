class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.3.1.tgz"
  sha256 "21920a2891cbe6d4a0216ea0b47c38db50c18e13fa5ac3c077c0b103d558928b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ad2991dc820115392cb16861add37eddaecc2b21a126f383744596355ff6d67"
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
