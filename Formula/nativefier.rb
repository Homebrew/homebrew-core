require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.5.1.tgz"
  sha256 "80254c083ab95ad72f14bc5ea56134562a1bd66fdce8d1ffb9e91d1d0147adf0"

  bottle do
    cellar :any_skip_relocation
    sha256 "24a900dc47011384bb95e29dd32b6d6b9aa19e5f7323f311fc9b4eaea25c6b09" => :high_sierra
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
