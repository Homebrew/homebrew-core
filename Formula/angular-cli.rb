require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.1.6.tgz"
  sha256 "044316a546453306cab032751c1cbfe060a9e117a1caf31918a2dc87895ab48c"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f5de2896e2110492954fa3c18b9122e98637fb4ef6eb115564c075eb1b62e2a4" => :catalina
    sha256 "6c48a94d73ac25e81db4e0830f4082b8928f9d2726183a24edbd50bb7395f726" => :mojave
    sha256 "0cb4c91fdb6e8bdc6ff4179ff9cd6140e236266ea0109a2d6dde650b705bc4cb" => :high_sierra
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
