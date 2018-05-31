require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.4.tgz"
  sha256 "77de0f138cdbc0cdf35ff0fe23cc79b4272db3f05cd34cdece00fffb8911b3f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "adf3d341d9e7cfd79ed3ba6b0e6a7149f07edb73b66ecfa6452a9b0ba26c906c" => :high_sierra
    sha256 "b48e332714a4598c2a4b6380545ec520538fcfa65878ec3ab2cceae4ee931d4d" => :sierra
    sha256 "0fb9d888ac4baa5f60fb70c9e0b75e23dc104b904cee7a457e09edb5dea7c4e3" => :el_capitan
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
