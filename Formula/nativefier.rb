require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.8.tgz"
  sha256 "d1bfbc42862c8c870805839bab3face57572909e253dc2b54270922adaec8025"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d9b3ed2997e3e8c2d8fec5d02ad5fdbf5f756060df1f533053640584ac40940" => :mojave
    sha256 "60eca3d492ff7842cd7255086f97c95c2191cf32a4431028242188e2fa298e97" => :high_sierra
    sha256 "b3ed912953fb15ff93438191b9cf08f60b2e31c788f4e7484b803fe08881f89a" => :sierra
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
