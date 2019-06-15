require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.140.tgz"
  sha256 "c491b2f6bdf5a98a1a2e4124ed9a1bdba59ed7ae1a88ee223cf922b24e111447"

  bottle do
    sha256 "52c55a3c5ce8533881f8fb9ccf0229801616b7c97518455779c1ee5ab3c05ed3" => :mojave
    sha256 "dfa7eb1274b6e9700f371bf5460a6cf76602b4739b846b5940af99abb2c015a0" => :high_sierra
    sha256 "537b34b004214603816e592789ec7453c947a488dfeabbaa55741278b62e1cef" => :sierra
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
