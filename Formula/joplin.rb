require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.150.tgz"
  sha256 "8baab0baf97ac77a10d05ca74abc03b4a8b78d53480d70420d6448ec4986bb8b"

  bottle do
    sha256 "e109e114f10667484a610ac694883c3c6a58791ceca6a2744c7f17d2f6dff207" => :catalina
    sha256 "53867d6ce8e1ae6981d7375ec60afa0500b8b31645673dea8fb35c201ef52732" => :mojave
    sha256 "dcf1c24522a4471089d0af2aca9b46c57540123f1f404aedad7f66a3bf82c9ab" => :high_sierra
  end

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
