require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.6.6.tgz"
  sha256 "18b0979554dfff1cf60589c1372182ee6b23a1bf54f4fbaaa2efc40a63876693"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d009b426051afce47e98a6e9f82791f8d3d94cdfb86efaff1fe9ddb0147a759"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d009b426051afce47e98a6e9f82791f8d3d94cdfb86efaff1fe9ddb0147a759"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d009b426051afce47e98a6e9f82791f8d3d94cdfb86efaff1fe9ddb0147a759"
    sha256 cellar: :any_skip_relocation, ventura:        "564994503d3494e0d1196880ca6fec123a9df83be96eb7ff7c47cf467ac2010d"
    sha256 cellar: :any_skip_relocation, monterey:       "564994503d3494e0d1196880ca6fec123a9df83be96eb7ff7c47cf467ac2010d"
    sha256 cellar: :any_skip_relocation, big_sur:        "564994503d3494e0d1196880ca6fec123a9df83be96eb7ff7c47cf467ac2010d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d009b426051afce47e98a6e9f82791f8d3d94cdfb86efaff1fe9ddb0147a759"
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
