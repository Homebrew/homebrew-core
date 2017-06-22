require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "http://alexjs.com"
  url "https://github.com/wooorm/alex/archive/4.1.0.tar.gz"
  sha256 "e2acbf03d260344a5dfb637835dd1009dd93a252a2376a97a29cd4dee660cb89"

  bottle do
    cellar :any_skip_relocation
    sha256 "492b0896c812f3ed390bd708c187499c5ca8433899e3821d43cf3e7b90d7796f" => :sierra
    sha256 "5a8b3ea63b26ba52346a8636aa0180a4478b71562a8b082ef1aeb586ebb45b1e" => :el_capitan
    sha256 "372fc997d71ef0988ef6fb6df3bd477ec92956d1069a9fa4fd98934dce040fbd" => :yosemite
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
