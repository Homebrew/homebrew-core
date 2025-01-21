class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.6.1.tgz"
  sha256 "b2a8ce62393c1994c64cfd37334af209a14b1e00b6ef85e1d07413b4dc3576b2"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628b95e84e52974d857469a3645becb8296a49970bb8d4c589d7384a9006481d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "628b95e84e52974d857469a3645becb8296a49970bb8d4c589d7384a9006481d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "628b95e84e52974d857469a3645becb8296a49970bb8d4c589d7384a9006481d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5082eaaecc833def7240d340ae3aa0ece9ca0bbf9b52f19c9a35742d6684bf72"
    sha256 cellar: :any_skip_relocation, ventura:       "5082eaaecc833def7240d340ae3aa0ece9ca0bbf9b52f19c9a35742d6684bf72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "628b95e84e52974d857469a3645becb8296a49970bb8d4c589d7384a9006481d"
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
