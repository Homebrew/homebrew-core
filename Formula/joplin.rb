require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.163.tgz"
  sha256 "226a28c3180c6ab7fc721e04250dccd88fe32bc9f645d3ba7e663e89abf09103"

  bottle do
    sha256 "a104ee7d47df75774ce8e89d2146ab8fe2c23b835b436def294e29846090c495" => :catalina
    sha256 "23d043a12ce27d0afad2c3d9d1e8979f6bb499d3d073be2e39702f411d72b479" => :mojave
    sha256 "5aec579f667bcbcb7d9eec4939cdb657312f236fb99bb8ce8088cf27f7f5de4d" => :high_sierra
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
