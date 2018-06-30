require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.110.tgz"
  sha256 "d48393e5bdbaf8a7a59b37774b6630c0be0ed6e5ed98d572d65cea2a28fff55f"

  bottle do
    sha256 "ccbe1e308a33ebec10c6cb4f5b460940b1d54dcbc9782af5e5776109f9c2baa3" => :high_sierra
    sha256 "782b80e50316a034fb5c98cb1a68e80868b3f20169f376f918c22d86946c166b" => :sierra
    sha256 "c8a4f0dd75ef7c04b182ce6f22042ab0eedaa0facc47ab3696eb9fd9617b049a" => :el_capitan
  end

  depends_on "node"
  depends_on "python@2" => :build

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
