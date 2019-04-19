require "language/node"

class Joplin < Formula
  desc "Note taking and to-do application with synchronisation capabilities"
  homepage "https://joplin.cozic.net/"
  url "https://registry.npmjs.org/joplin/-/joplin-1.0.124.tgz"
  sha256 "6da64d5ff859d2e6648ebcdc4e99486461db4eba13d4827f0261ac4d5be8de35"

  bottle do
    sha256 "907470b99b73cd37d1144679f010a76313ac4d5d8c1e800485706088dd9b1617" => :mojave
    sha256 "e4dc1b286503a91c4a56d8ea95e82eca50f010d03839c8a4668ad6691a1bb4f3" => :high_sierra
    sha256 "24749d28620ca4713f3c6f4d9e892d6815d23a8234f1f35b125a8e16793f3bc0" => :sierra
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
