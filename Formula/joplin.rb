require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.124.tgz"
  sha256 "6da64d5ff859d2e6648ebcdc4e99486461db4eba13d4827f0261ac4d5be8de35"

  bottle do
    sha256 "3799db4cb2158b10df411b3fda68d8d15da46cabdd83c9b6b06cf7572eb5f1e4" => :mojave
    sha256 "e03b68edfeb93e86fbb308df5c09287d559cf662e8544c64467ead0473a662e2" => :high_sierra
    sha256 "1b50e730bcf3de2d3acbb7b759b5fa46082802a34a3591bdc19e022dcc59c57d" => :sierra
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
