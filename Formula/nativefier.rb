require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.1.0.tgz"
  sha256 "40126d6652680753f4501e97e7ae980311892ed8208e88b322f4971cf95c47b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cae7d4d16f46ea1624ada70c08e81d0c7675123966310b2c3b06678555e8bc5" => :sierra
    sha256 "173a5a5cf523ec75c02055e881ca1293ea27626839ccf4038e3b2fbd2ae26bc2" => :el_capitan
    sha256 "739ee2f4ffcfaa7845f4b021030dd442e1214c7ad6de812d29c829369a290fd0" => :yosemite
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
