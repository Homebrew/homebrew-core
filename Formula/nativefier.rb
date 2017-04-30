require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.3.1.tgz"
  sha256 "85b6bc8f137c477fbb1e6032b947db3034807b768d8d9c9699bb100d7a1a076c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f85b38df21e1066738d3b38fec34df6e600649263a26535d9b6d30754b3faaa" => :sierra
    sha256 "9b0d1aebdc01dc07f4b642a985d53ca88a31d31affbcbb48534bfebd12d1e7ce" => :el_capitan
    sha256 "965cdbe7854bf13e42a72dfa4ed97680ebf0afec35fb198ecd0e830cb4082d7e" => :yosemite
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
