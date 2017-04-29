require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.3.1.tgz"
  sha256 "85b6bc8f137c477fbb1e6032b947db3034807b768d8d9c9699bb100d7a1a076c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fd0fa50a466f1cd60d786eb1ef15f6c18154ba34ed5d4f954b9dead28a21fe6" => :sierra
    sha256 "cfde4bd4901ac331d01f76416c178c8f6858992b61329739556497eba1eb5057" => :el_capitan
    sha256 "bf1f29f7cd9110a046a2e8f1d30d28a2fbc5b2b5c8a7dff063e3942058260e66" => :yosemite
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
