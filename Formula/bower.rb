require "language/node"

class Bower < Formula
  desc "Package manager for the web"
  homepage "https://bower.io/"
  # Use Github tarball to avoid bowers npm 4+ incompatible bundled dep usage
  url "https://github.com/bower/bower/archive/v1.8.7.tar.gz"
  sha256 "1935db25df5796c5ea8b71bf1a0e740c3c71397a5eb9d1d7e07bb24dba3e9e0f"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b68e3317ee8d103693a9782152bb933a47ecd17a2a463dd7551e30c142d1280" => :mojave
    sha256 "3f84d1611116dbf28a68ac3dca79ba9c346b533da631066b8f3d48777074a765" => :high_sierra
    sha256 "bcfe567e0ed7cb3181fc35d5fcbbed408157ff341918283e7b73ed39eb9f20ce" => :sierra
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
