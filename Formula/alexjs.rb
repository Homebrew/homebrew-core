require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "http://alexjs.com"
  url "https://github.com/wooorm/alex/archive/5.1.0.tar.gz"
  sha256 "82b8bbd2e1781138a9147bfda584f7da3da92f782d18d23fd091b0fd105ddcad"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7802ccccbe316a876959d65ee0f967752811d486b99e228dc3336e98dcddf80" => :mojave
    sha256 "98235c0024fdbf9109169020bfbe6e184e6d64843ee29d0c532aa2703650ba08" => :high_sierra
    sha256 "89e37a748cc72279043da0fd9d7208f5dbe4612d1823d628de33b1a8c6f9e90e" => :sierra
    sha256 "2010daebcecbbe252a3d57b1144734793177027d699826cf67a632ea4d6b475d" => :el_capitan
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
