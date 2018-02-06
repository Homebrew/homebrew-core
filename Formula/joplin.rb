require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.93.tgz"
  sha256 "cb91ed0dfce94f706cafa007f7027ba3e76638169780ed7938b5e8868e8a2437"

  bottle do
    sha256 "64c8f5c40b5e84721bc16f7080c067bab2d5de8a9bf7a9ea7b66b7ff612884ea" => :high_sierra
    sha256 "f6a9699f98fb6dd3bf2204843130820c197cd2f2e0b9c1bb796a283c8125c26f" => :sierra
    sha256 "4ddb85fb890e0dc47c829860d7d15a7bc57f03b3e20d8ea35c57c29f633a6aab" => :el_capitan
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
