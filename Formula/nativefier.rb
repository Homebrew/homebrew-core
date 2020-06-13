require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-9.0.0.tgz"
  sha256 "2743c4c1339c15b8cf7f93ea0532b557ff6cdcc16dc38eeb64d0f7a99e7d997c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a87772bda684a90e032480a91ab7cad00546c545e2be54e40f2665bd4ce4afcf" => :catalina
    sha256 "3f20cb28094faac504d879e8cbeb01c785ee9d1cc1c0bc1a8607a2db78176f4f" => :mojave
    sha256 "f8005868540a210382084f726160f4d22352e122442a617317a8f88d6cfe7dfb" => :high_sierra
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
