require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-1.7.3.tgz"
  sha256 "29b70e40e4f9f64fd40d22e5a4bfd48d7a8031cddb3fc716911a04124c4bf989"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c675da9048f5e29de74e21b8ac6879214e84489c25cd3a00f7c7d86690e36ec"
    sha256 cellar: :any,                 arm64_ventura:  "2c675da9048f5e29de74e21b8ac6879214e84489c25cd3a00f7c7d86690e36ec"
    sha256 cellar: :any,                 arm64_monterey: "2c675da9048f5e29de74e21b8ac6879214e84489c25cd3a00f7c7d86690e36ec"
    sha256 cellar: :any,                 sonoma:         "667b9351010a013c0a672ccbd6eab71d091a87ea82be0f82c172cb75462c4c25"
    sha256 cellar: :any,                 ventura:        "667b9351010a013c0a672ccbd6eab71d091a87ea82be0f82c172cb75462c4c25"
    sha256 cellar: :any,                 monterey:       "667b9351010a013c0a672ccbd6eab71d091a87ea82be0f82c172cb75462c4c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ac14fb2dc00aed267fba4f084816ea04176143a26884c140420621240acb34e"
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
