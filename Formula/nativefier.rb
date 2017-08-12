require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.4.1.tgz"
  sha256 "c6498a57a02a31416c8452fb86dbc8dcfd927a069646d53c4aeb67cf848f87ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "d799ed13528dceac7edd6b492ced6ee0cf4cc576b9adec1aa2bf4a03ae531d6d" => :sierra
    sha256 "8b48900b5dba106797c3e36dc3177552289e6ea97ce989c4de6e252711e7dcbd" => :el_capitan
    sha256 "2fdb6e8c19023f83c8aab09aa907ef9d5a87eb88c4f5406b3c235ffba4080944" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
