require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.1.2.tgz"
  sha256 "aca659da30c4c3e25483fca656f60b35b521f397f1edf5fb4d5eaaf2a65d83e3"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1b522aa170108a5fd7e72663f19e892e507e27b35fa74948f513bde07979052"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1b522aa170108a5fd7e72663f19e892e507e27b35fa74948f513bde07979052"
    sha256 cellar: :any_skip_relocation, monterey:       "42a7d3d98045a46a4818a40429bbd94311016fa2b2244da2b84780b3a3d5a391"
    sha256 cellar: :any_skip_relocation, big_sur:        "42a7d3d98045a46a4818a40429bbd94311016fa2b2244da2b84780b3a3d5a391"
    sha256 cellar: :any_skip_relocation, catalina:       "42a7d3d98045a46a4818a40429bbd94311016fa2b2244da2b84780b3a3d5a391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b522aa170108a5fd7e72663f19e892e507e27b35fa74948f513bde07979052"
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
