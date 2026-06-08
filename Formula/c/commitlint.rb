class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-21.0.2.tgz"
  sha256 "410d63fababcfa9f17af946a9490893c9f25d24776e70883a2140c26edf61459"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc76c17076623897140531b4ca656655a6f07f822e564636a86ef2a0377c3d81"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove comment to build :all bottle
    node_modules = libexec/"lib/node_modules/commitlint/node_modules"
    inreplace node_modules/"global-directory/index.js", "/opt/homebrew", "HOMEBREW_PREFIX"
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
