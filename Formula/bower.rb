require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  url "https://registry.npmjs.org/bower/-/bower-1.8.2.tgz"
  sha256 "6bcf10e9c192fdbd6e89f98e431e095764c8571f66bcd6dd08fbcbd52e8dd722"

  bottle do
    cellar :any_skip_relocation
    sha256 "22f93ddce637d1afb0824e23e61f9eb69ebe1d7a4d9c0aadd0e4db8fb54c8efa" => :high_sierra
    sha256 "eb640d5ee479ffe61ee5e1128c15c86af0042733789025c387bc9145758dc130" => :sierra
    sha256 "dd8959cfbb739113122d4ecfe329cbd25fc217b11a9b7e8c4ca1a1cbad3d71e6" => :el_capitan
    sha256 "bc7b25bbac3df03684497f02311d1990a858ee90346f9f196875e564db99f6d6" => :yosemite
  end

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
