require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.106.tgz"
  sha256 "c1f1b19f0d078cd232bce5f62e8ec4f1a69bfcddf1cb90701c7cd7a4ecc59613"
  revision 1

  bottle do
    sha256 "623689379519111d6d9169b788d9037b9fc04c822ab98fbb1775731483558a2c" => :high_sierra
    sha256 "37f80d50bfea27769e8fedab3394e2835868a483e34cdfbb5ddca73a09683c20" => :sierra
    sha256 "4478b84cf2bbb5b7b08e2c05f6c0c855687a12d164934d50a1bde9813af55cd1" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build

  def install
    # upgrade the sqlite3 dependency to a version with node 10 support
    inreplace "package.json", "\"sqlite3\": \"^3.1.8\",", "\"sqlite3\": \"^4.0.0\","

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
