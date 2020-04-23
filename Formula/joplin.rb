require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.163.tgz"
  sha256 "226a28c3180c6ab7fc721e04250dccd88fe32bc9f645d3ba7e663e89abf09103"
  revision 1

  bottle do
    sha256 "0857e6f3a84e04689c89e4037fecd068ef8ddc3b127bc5cb1e0a138d3416fdfd" => :catalina
    sha256 "0e9e986dfea2eaf4c8953fbc057edbe577f3b005eb40ee8f2ea9f23c31d5fcc7" => :mojave
    sha256 "edaeb39d901c22d87dc26c3bd99901f42d2e2a88e20a581e6bd81f52f01d591d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "node"
  depends_on "sqlite"
  depends_on "vips"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec),
                             "--sqlite=#{Formula["sqlite"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
