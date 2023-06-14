require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.0.tgz"
  sha256 "266d8df7332a1a75e29dcfe7d4db68a99679744563ddab6483554408c3721f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69979d82fb8712eb1dc3fdb9e015a5c378ad18c24361293bf35efec3dd89b100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69979d82fb8712eb1dc3fdb9e015a5c378ad18c24361293bf35efec3dd89b100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69979d82fb8712eb1dc3fdb9e015a5c378ad18c24361293bf35efec3dd89b100"
    sha256 cellar: :any_skip_relocation, ventura:        "39b5df6de5406f2b5d315499050f30811ccfb902d9db54602b5a65bdf2d3156e"
    sha256 cellar: :any_skip_relocation, monterey:       "39b5df6de5406f2b5d315499050f30811ccfb902d9db54602b5a65bdf2d3156e"
    sha256 cellar: :any_skip_relocation, big_sur:        "39b5df6de5406f2b5d315499050f30811ccfb902d9db54602b5a65bdf2d3156e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69979d82fb8712eb1dc3fdb9e015a5c378ad18c24361293bf35efec3dd89b100"
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
