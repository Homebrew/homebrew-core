require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.2.1.tgz"
  sha256 "680a6a30a95eb2dcacfe9c7916d7ed604c678fcfcbb366f9970edb32e4b1348f"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cd8e304498f3b5d8d67f7ceee6bdc61bf30ae610a22fd339bd6afc8fa59596c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd8e304498f3b5d8d67f7ceee6bdc61bf30ae610a22fd339bd6afc8fa59596c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd8e304498f3b5d8d67f7ceee6bdc61bf30ae610a22fd339bd6afc8fa59596c"
    sha256 cellar: :any_skip_relocation, sonoma:         "96e667c33aa9e4411a9f6ddc1f7199b616657591ddbd283e1530ed2e8743520f"
    sha256 cellar: :any_skip_relocation, ventura:        "96e667c33aa9e4411a9f6ddc1f7199b616657591ddbd283e1530ed2e8743520f"
    sha256 cellar: :any_skip_relocation, monterey:       "96e667c33aa9e4411a9f6ddc1f7199b616657591ddbd283e1530ed2e8743520f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cd8e304498f3b5d8d67f7ceee6bdc61bf30ae610a22fd339bd6afc8fa59596c"
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
