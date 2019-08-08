require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.2.1.tgz"
  sha256 "15a0b18dfa45c39ed8ff29a33927a44eaeb21c1e9b4e647cb1f7229c2d3ad856"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b0d584bcc20d52648676a64ad3c1dbad9deb9cfcfc56cdea588ac25f3bc99f2" => :mojave
    sha256 "a437145e0eeb408f8b6663287e121d3f36ea1a5fa6a3eac8172c155e0f6e1a5c" => :high_sierra
    sha256 "f25550230bee10650e1598df7c0a50ee1ee96e142c1f3e856cc8226e19fab1c6" => :sierra
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
