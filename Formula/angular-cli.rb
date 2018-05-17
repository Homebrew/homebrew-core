require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.2.tgz"
  sha256 "69efe260dd085ec3d0b3b2258ac984d6edb760c8b20011f3fbcaeec4b6eeff4f"

  bottle do
    sha256 "179ac9a13ebc06f5b454f72b5a42070e144f548aeac00692d36eaf5dde2946e1" => :high_sierra
    sha256 "2852b7acf29a2f4f372bc7dded66d540c4255151a8cff5617c09ee88b3b63f71" => :sierra
    sha256 "308aed0091158b64ca98f2b37b67d744c6f482ba9c02f78a7b1a1ce5de903ec6" => :el_capitan
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
