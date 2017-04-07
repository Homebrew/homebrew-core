require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.1.0.tgz"
  sha256 "40126d6652680753f4501e97e7ae980311892ed8208e88b322f4971cf95c47b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1113afaea327b39acdedca91ad3dbeec99ff591f16a5b2375ec524503c79f8e0" => :sierra
    sha256 "a6d6b504e1d2c4a9c80137bdb264ce6ef8d4dfdb20a910eb6cfbc0aa9735c120" => :el_capitan
    sha256 "b76f98e3365b98f50518a6ef7955523fb9fab538e1158d383a0c385f50673233" => :yosemite
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
