require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.3.0.tgz"
  sha256 "37ebb051e3600e731fc3be3cf3b84b4fa88d8003d8b8c99dffa7dc4ea927c37e"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b5b14c6519eb33d2d2194addadf4f5cc2cce104d144b39eccff3c6d8c92479c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "850358d8be90b8a73f591d1263b4033feb573e3b8dfb23f54f10b23e4337d3e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "850358d8be90b8a73f591d1263b4033feb573e3b8dfb23f54f10b23e4337d3e1"
    sha256 cellar: :any_skip_relocation, monterey:       "c25843482c50c727a648b3fee20d3e9ccc705379658143faaefa398d4ee811ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25843482c50c727a648b3fee20d3e9ccc705379658143faaefa398d4ee811ae"
    sha256 cellar: :any_skip_relocation, catalina:       "c25843482c50c727a648b3fee20d3e9ccc705379658143faaefa398d4ee811ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "850358d8be90b8a73f591d1263b4033feb573e3b8dfb23f54f10b23e4337d3e1"
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
