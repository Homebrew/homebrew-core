require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.7.1.tgz"
  sha256 "5d8a810c6c4486101dbbbe35cf7e4a6496ebff5ca24c5a9bf9a0034f09d6221f"

  bottle do
    cellar :any_skip_relocation
    sha256 "255a674c83a21d5dd6042a5af37be7b24119ff780fc30285c81fabc3d1f02792" => :catalina
    sha256 "12ebffa0ffec6f533e46f69a21b7da9ae015df891e17273e1e12d1a5b94bac08" => :mojave
    sha256 "efb300fdf2c06f3c5a0c0a84cf3b55310f9bff64883931e6d9579222956ee85b" => :high_sierra
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
