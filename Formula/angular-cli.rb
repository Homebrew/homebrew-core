require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.1.2.tgz"
  sha256 "72be54e8777b1d9328164fa8274c979bff8e2c37b25e8b53c6d1c419f3a52e37"

  bottle do
    sha256 "55ddb4c10b8aaba9781cc6993cfaabca8c6a1dba39807d30e919c441778bd7fd" => :high_sierra
    sha256 "d99ec499b120bd19ff7dc12674e676a4872d94c845887ee80b79f3a96e2d1968" => :sierra
    sha256 "4fffeaf28e2ddd868389f75b30523750ba07e1d3eb632dbc8128f9dd25e350af" => :el_capitan
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
