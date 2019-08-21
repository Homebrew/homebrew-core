require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.141.tgz"
  sha256 "2f7c841a19a45466f9e84325e6c718b0116b450095aa6058da303321c7c225f1"

  bottle do
    sha256 "d919343dfc489383ede02badc16b5bbb6a73cda4c1fd4a7a66a3b6e47bf0fd71" => :mojave
    sha256 "b4bfaa0d82f22424af6ccd9ea7d7a04304b9690bbef0a46680b46e031a396366" => :high_sierra
    sha256 "d0f509be6170917f2173a4dd34624d98be18845f1e70c9ae97845b6abaf9540d" => :sierra
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
