require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.139.tgz"
  sha256 "b46dc94b403d6656c74974b95dafccfb59a4558c11bada7f02dff6e635c6168a"

  bottle do
    sha256 "9ba2992c8b8ffcf7b6f38d768086ba6d894f6d4d73ba90f9f77a39d7a085d1ce" => :mojave
    sha256 "af23a23baaf288e03d7adeba6c446fcff51f3357a6f1edf4db904f2be34a2a5f" => :high_sierra
    sha256 "1c2393b39fc1e469d4fd026e1612422d0103638778f055b003233f8b89368093" => :sierra
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
