require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.2.2.tgz"
  sha256 "bc0ecb4e1e336cb919a0cf61b29893476c7ee6a0e1505707dcfc7f97af0b2e70"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff7e38a061e4646a651835b855d679d5c6fbcd70273d2e03f26a940a65fb860d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff7e38a061e4646a651835b855d679d5c6fbcd70273d2e03f26a940a65fb860d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff7e38a061e4646a651835b855d679d5c6fbcd70273d2e03f26a940a65fb860d"
    sha256 cellar: :any_skip_relocation, sonoma:         "934c2d337ff0e5c06374ee345949574113cbe0a63e46b2ccc69d62c5583e46f4"
    sha256 cellar: :any_skip_relocation, ventura:        "934c2d337ff0e5c06374ee345949574113cbe0a63e46b2ccc69d62c5583e46f4"
    sha256 cellar: :any_skip_relocation, monterey:       "934c2d337ff0e5c06374ee345949574113cbe0a63e46b2ccc69d62c5583e46f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7e38a061e4646a651835b855d679d5c6fbcd70273d2e03f26a940a65fb860d"
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
