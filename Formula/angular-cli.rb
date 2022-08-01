require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.1.0.tgz"
  sha256 "e7ab3276eea7653fbf9710131d3f5263bbaa28329c1586601a7fa4390d485302"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4a446c86175201f7088b007b8cb60e33b2fcfe1c7a791d236dc2e680fbe0b74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4a446c86175201f7088b007b8cb60e33b2fcfe1c7a791d236dc2e680fbe0b74"
    sha256 cellar: :any_skip_relocation, monterey:       "c459401b6f7856fec6ba0edaa211bfefb6e67047430b371a55827a64a931e3ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "c459401b6f7856fec6ba0edaa211bfefb6e67047430b371a55827a64a931e3ec"
    sha256 cellar: :any_skip_relocation, catalina:       "c459401b6f7856fec6ba0edaa211bfefb6e67047430b371a55827a64a931e3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4a446c86175201f7088b007b8cb60e33b2fcfe1c7a791d236dc2e680fbe0b74"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
