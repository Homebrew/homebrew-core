class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-19.7.1.tgz"
  sha256 "1d0a7b0630d1141a3a1caced1677135cc0b1cdb0a06870e97bce5270c7a10bf2"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfd0478b8b34a50935d9bc2ffa16c48f93e206df59c16507904dec9bbb8f52d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfd0478b8b34a50935d9bc2ffa16c48f93e206df59c16507904dec9bbb8f52d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfd0478b8b34a50935d9bc2ffa16c48f93e206df59c16507904dec9bbb8f52d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1b4e3f48ddf0bf444b993de979b63263ee4b979000097254cde2bc18a33bd58"
    sha256 cellar: :any_skip_relocation, ventura:       "e1b4e3f48ddf0bf444b993de979b63263ee4b979000097254cde2bc18a33bd58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfd0478b8b34a50935d9bc2ffa16c48f93e206df59c16507904dec9bbb8f52d8"
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
