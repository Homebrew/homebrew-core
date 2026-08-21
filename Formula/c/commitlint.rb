class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-21.2.2.tgz"
  sha256 "5deaaad9d9387ecb304712890d46a2cb1cfe709bed829b071ac1e596e67a06f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e95cdcb928cfc9a06e6bee1de928683283c68dc81761db9eaffdd2087d2d6fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e95cdcb928cfc9a06e6bee1de928683283c68dc81761db9eaffdd2087d2d6fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e95cdcb928cfc9a06e6bee1de928683283c68dc81761db9eaffdd2087d2d6fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1bd4a522057e2073a3a8636fc421e4d2cef243f662963e1f78fbe8fe22085593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c933a311c3ab5fd8289d7f2a24b3262f4a9054dbbdde6718e4671c098de430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebaebe0ae168c555e310a5795a1d9aaf93d24d1d10ea926bee57434bf98e470e"
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
