require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.10.tgz"
  sha256 "7e97d25c612f8e1732e8390d0bd1cc03a0f77305213c131242c2fce321409b78"

  bottle do
    cellar :any_skip_relocation
    sha256 "0eb9985a505123f198bb3f35e0a8fbcc5242f426715fbcdb65e51a0be1acae44" => :mojave
    sha256 "37579ab9bc56e508287f79053c5718ae78364ae57ce40d8295f1625f2247034e" => :high_sierra
    sha256 "b9c03ca66be0b5c0fd3b47f554dca00eaf734498d48d727ae752e738ad5f8da9" => :sierra
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
