require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.1.tgz"
  sha256 "f7d8e2dbe722dbac92c4a4aaecbc542c7cc4683a10e51bbfc3a1cab864a1091c"

  bottle do
    cellar :any_skip_relocation
    sha256 "60dd1cceffb7a88f0e2764f438267c1581b3daeed98ec84b048be88041a53b21" => :high_sierra
    sha256 "4e746085f86f40122b2a9810dfdc7630a05dd6d8807827903ffd681ee5edc31f" => :sierra
    sha256 "3d798efdaa4b664bf3711cf3e2880de1ffd6e93661bb339519c621acce4d714b" => :el_capitan
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
