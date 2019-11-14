require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.19.tgz"
  sha256 "c062b52ac2503fea168da198ec184992b7407b1560e8bb17eab3b78689d2db43"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa5e28a2668054b8f434aa124473b8d4a076df43f463b8273658f0c912b916e9" => :catalina
    sha256 "1fd64ff1dd86c1fb9c6d740721919861094bac95c2bec2006b7ff7e394e71037" => :mojave
    sha256 "6f86464404a3d3eb82adbd7342d8c29ee7fd0482d2b3977d289f7447a7387ac1" => :high_sierra
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
