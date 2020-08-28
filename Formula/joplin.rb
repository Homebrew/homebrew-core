require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.164.tgz"
  sha256 "d4292ee33a108dd917d951644d0be7fe63b50d8108504758b1ad7c0b798c0539"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "b1db2009b91e989c0fef249e97cd6510061bc76d7deb4156c5b0ff48cf1b25f6" => :catalina
    sha256 "db19b4eaf3006ab2d5854cfe40385f5786f67038f593fa8f250ad62af9326c0d" => :mojave
    sha256 "20a106fc8277d35fbc9fab011d62e3c3184249c9c87a30282094717294145bf8" => :high_sierra
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
