require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-8.0.1.tgz"
  sha256 "671304f07dabb61d1a818b45b9d9605c6576aaab8e9f8f54dfbdde0ee36ae8bf"

  bottle do
    cellar :any
    sha256 "adfcf431764c0601a520a0e7d2a3fe36b02767790af07301123ce8e8f95d1b6f" => :catalina
    sha256 "3029f92446746edfcc368a2f2d7bef1ff85b3f96b0ca112eb73db59b10e3c6ae" => :mojave
    sha256 "2e9d8e425b818fde62dbf3a6180974ac4a2472eb61cec5a9bb2dbc5f168f8972" => :high_sierra
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
