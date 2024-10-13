class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.5.0.tgz"
  sha256 "2d2705b457826f260f9d76671bb75080ce0ff5bfd44dcc4d15627fa21a8d56a2"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d8b1f57ca8238fb8a9f3af7d5298c0b9380ab2f3f108242efa588e6f6bd39cf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8b1f57ca8238fb8a9f3af7d5298c0b9380ab2f3f108242efa588e6f6bd39cf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b1f57ca8238fb8a9f3af7d5298c0b9380ab2f3f108242efa588e6f6bd39cf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8b1f57ca8238fb8a9f3af7d5298c0b9380ab2f3f108242efa588e6f6bd39cf9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5723621d0ec49d9e914b6a83bb2693bf407301fe3e8f6bac75fe9e8a0e44e004"
    sha256 cellar: :any_skip_relocation, ventura:        "5723621d0ec49d9e914b6a83bb2693bf407301fe3e8f6bac75fe9e8a0e44e004"
    sha256 cellar: :any_skip_relocation, monterey:       "5723621d0ec49d9e914b6a83bb2693bf407301fe3e8f6bac75fe9e8a0e44e004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8b1f57ca8238fb8a9f3af7d5298c0b9380ab2f3f108242efa588e6f6bd39cf9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
    assert_equal "", pipe_output(bin/"commitlint", "foo: message")
  end
end
