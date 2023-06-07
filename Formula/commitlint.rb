require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.6.5.tgz"
  sha256 "6f57b54aec64b81e1b28c18d740e2c2490aec0f605fe71ea00f468eae68bc97c"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a66fe787abfba0308a3866ea58128b6f4209932866301e38be802b7f7a1b19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a66fe787abfba0308a3866ea58128b6f4209932866301e38be802b7f7a1b19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a66fe787abfba0308a3866ea58128b6f4209932866301e38be802b7f7a1b19"
    sha256 cellar: :any_skip_relocation, ventura:        "31d751b9f9d9bc8fef761754ac8df289514a3b47e6b33315244835613bd96015"
    sha256 cellar: :any_skip_relocation, monterey:       "31d751b9f9d9bc8fef761754ac8df289514a3b47e6b33315244835613bd96015"
    sha256 cellar: :any_skip_relocation, big_sur:        "31d751b9f9d9bc8fef761754ac8df289514a3b47e6b33315244835613bd96015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a66fe787abfba0308a3866ea58128b6f4209932866301e38be802b7f7a1b19"
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
