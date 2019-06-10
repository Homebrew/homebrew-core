require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.140.tgz"
  sha256 "c491b2f6bdf5a98a1a2e4124ed9a1bdba59ed7ae1a88ee223cf922b24e111447"

  bottle do
    sha256 "09d6f3733e71a5e53dd40abd7c71d56dc66ca49d27269e078078a63b8b2fd3ab" => :mojave
    sha256 "ff75f78cd23297ea2669437cc7c59d8ab301fa49156ae4bc4a45d66efbe52f8a" => :high_sierra
    sha256 "d176f03563a0ceeaeeae813b6b49afbbf34d92e81ddd5062a536915c272ee64a" => :sierra
  end

  depends_on "python@2" => :build
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
