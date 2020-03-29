require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.0.tgz"
  sha256 "1c34de7d76f5d92e350ef9bb79b9c16091ddb678cec1ee88f7d0a813a646c32c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e10d316b88b2aed8ca1f6386fe904e7daf1ca4bb18cb3fdae202cced77257669" => :catalina
    sha256 "5a5488481e5be86ed2dc4e7cc39f0ebf92f97b3627bd4b8c577b1da1d978b3db" => :mojave
    sha256 "3bb917489fa3de79cf3c8de8509d5c579a75a4f4556054e5c4c6b2504e2a4f00" => :high_sierra
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
