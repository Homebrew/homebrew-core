require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.109.tgz"
  sha256 "671b950d3f669c75478d9a164a77d45b50cd042f7d295f623de817b44e87cb39"

  bottle do
    sha256 "ccbe1e308a33ebec10c6cb4f5b460940b1d54dcbc9782af5e5776109f9c2baa3" => :high_sierra
    sha256 "782b80e50316a034fb5c98cb1a68e80868b3f20169f376f918c22d86946c166b" => :sierra
    sha256 "c8a4f0dd75ef7c04b182ce6f22042ab0eedaa0facc47ab3696eb9fd9617b049a" => :el_capitan
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
