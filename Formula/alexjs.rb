require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "http://alexjs.com"
  url "https://github.com/wooorm/alex/archive/5.0.0.tar.gz"
  sha256 "5fd5429372b0745020fb4789df9ef7bb14f02173e4e90c79dcf06a3de1093c8b"

  bottle do
    cellar :any_skip_relocation
    sha256 "abac2c52f7cd7567f2777c0e5b262064437863f4f75313d11eb76e9e7878fdbc" => :sierra
    sha256 "db81db3e1657c63523b7d1564085909854e8ed61c4fcf31d3868ee0e43ca4c62" => :el_capitan
    sha256 "6be3f84ce78a39997be986bb1d6c3e679fabd4d83fb3389f5b09375aac913802" => :yosemite
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
