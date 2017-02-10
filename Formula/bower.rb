require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  url "https://registry.npmjs.org/bower/-/bower-1.8.0.tgz"
  sha256 "df634fcbb57f8877914ceeff794c88bca0c8a262d9c9f12f08c37ab13599aaa6"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert File.exist?("bower_components/jquery/dist/jquery.min.js"), "jquery.min.js was not installed"
  end
end
