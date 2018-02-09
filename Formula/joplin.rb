require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.93.tgz"
  sha256 "cb91ed0dfce94f706cafa007f7027ba3e76638169780ed7938b5e8868e8a2437"

  bottle do
    sha256 "301c01e192347fc8d261e700e1b20257a92d202be6cfe85224ef130be208d4cb" => :high_sierra
    sha256 "afa355e7d5da05cdfadf2593027cae51fb9703e2bd4f5c2d481ea0aea45c464e" => :sierra
    sha256 "a6744e809fd48f90244f2eba8c0e2b6c4a9da53d29714de09ff228588ea7294c" => :el_capitan
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
