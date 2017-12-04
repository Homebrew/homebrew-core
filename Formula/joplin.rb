require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "http://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-0.10.65.tgz"
  sha256 "52dcd067e670ede25a74d06a10223a9d7e134e56606219621a21dc3915127f8c"

  bottle do
    sha256 "ea7d077c77faa75cf298b8e082cbe467a31ee832f1c48cb9e23abe1f9d06e5e8" => :high_sierra
    sha256 "0109e3968c283afb1bf13f8ea906573af6294025e5b92d142f0575d251d02b96" => :sierra
    sha256 "0fbbb24a14e8f1932f1a46c68ef402158c93641753dd9c1dfbba1e92d09bbf5b" => :el_capitan
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
