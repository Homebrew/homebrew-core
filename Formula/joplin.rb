require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.92.tgz"
  sha256 "4aac82c5f5b12bc1b71b2a59cf1b356c65eb745d604d493a02585ea9ef905597"

  bottle do
    sha256 "bc0b1b3b93f52a351e45a0e71cd2e00a90cecdd8e486242fc49d28846e40d0ee" => :high_sierra
    sha256 "235a68e3a37e579a3a2b44c704d79d0564cd5c0e0eea8b0a14727a0f4cdc94eb" => :sierra
    sha256 "7fa7310eaa02a9d692649a06c4c11401e78cb5949019aded96f777c8c0c00226" => :el_capitan
  end

  depends_on "node"
  depends_on "python" => :build if MacOS.version <= :snow_leopard

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"joplin", "config", "editor", "subl"
    assert_match "editor = subl", shell_output("#{bin}/joplin config")
  end
end
