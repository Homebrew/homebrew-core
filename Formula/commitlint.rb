require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.4.3.tgz"
  sha256 "3253d8da830ea84b7d8241b114bea97a0ab62d5632aedea16104096dbd39cdaf"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d67f9b5c987a2c47c2bd7b324e2406a5f8896c71d2c91fba07b64fad127b2d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d67f9b5c987a2c47c2bd7b324e2406a5f8896c71d2c91fba07b64fad127b2d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d67f9b5c987a2c47c2bd7b324e2406a5f8896c71d2c91fba07b64fad127b2d5"
    sha256 cellar: :any_skip_relocation, ventura:        "424e8d447471327fa14c6cad2178b15ffd8c7c865fb6a37ba841410d58f2bafb"
    sha256 cellar: :any_skip_relocation, monterey:       "424e8d447471327fa14c6cad2178b15ffd8c7c865fb6a37ba841410d58f2bafb"
    sha256 cellar: :any_skip_relocation, big_sur:        "424e8d447471327fa14c6cad2178b15ffd8c7c865fb6a37ba841410d58f2bafb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d67f9b5c987a2c47c2bd7b324e2406a5f8896c71d2c91fba07b64fad127b2d5"
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
