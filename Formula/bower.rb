require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.7.tar.gz"
  sha256 "1935db25df5796c5ea8b71bf1a0e740c3c71397a5eb9d1d7e07bb24dba3e9e0f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "71091cd752679276938b3d522b3a3208028ac39d7567621c6be01d9ff8176208" => :mojave
    sha256 "055539589006d7eeb83b1ce11bf54e120660790c5795fc73acf5842691984e6e" => :high_sierra
    sha256 "aaaf74c6e92afb1cb2f2907a8e8380414915aac75a00e03c2356a6099b33520e" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"bower", "install", "jquery"
    assert_predicate testpath/"bower_components/jquery/dist/jquery.min.js", :exist?, "jquery.min.js was not installed"
  end
end
