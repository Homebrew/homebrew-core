require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.6.11.tgz"
  sha256 "9d4c8552949aef0f2964a34c5374b57571006ad88028a9240522468169ade376"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "caab8362f8b155c169ee95f4e7c51f16612719e3822617768d1c47e4bd81f925"
    sha256 cellar: :any,                 arm64_ventura:  "caab8362f8b155c169ee95f4e7c51f16612719e3822617768d1c47e4bd81f925"
    sha256 cellar: :any,                 arm64_monterey: "caab8362f8b155c169ee95f4e7c51f16612719e3822617768d1c47e4bd81f925"
    sha256 cellar: :any,                 sonoma:         "d002ae74df9f60d95650b9eac1507762bb56c463cc9aa21aa99280bc223537a8"
    sha256 cellar: :any,                 ventura:        "d002ae74df9f60d95650b9eac1507762bb56c463cc9aa21aa99280bc223537a8"
    sha256 cellar: :any,                 monterey:       "d002ae74df9f60d95650b9eac1507762bb56c463cc9aa21aa99280bc223537a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a94a53400ab06025ed9c2c95c49f607a0914ba18deafdadfe51626310b071910"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
