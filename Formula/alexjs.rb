require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/8.1.1.tar.gz"
  sha256 "eb9b7b29f1c4dcd660da35e79bcca63bdfb8cab6eab2a7c28e77345bb6348f5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7243b8eff6ed19d7bd0e1a4de718b2d1402a29550f0bd86b44089d56c9351ce9" => :catalina
    sha256 "c9ea2efc68c6fd108fe37e679973dbf6e2f698a31a70c32c01ab7870a9d9dc50" => :mojave
    sha256 "5ee3fd2c0c5e56bdb56fd7de0e717af9a7998a66e8a2b14374fc6cc2b36bfd86" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
