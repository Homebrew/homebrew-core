require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.1.tgz"
  sha256 "f7d8e2dbe722dbac92c4a4aaecbc542c7cc4683a10e51bbfc3a1cab864a1091c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1754ef5cffd4abfd37e6207b49cf2146891c363c6c6af88bef1ef7473d0c2c5f" => :high_sierra
    sha256 "8311b52abae6cde47ff12b19054f018f45fd1efddf2a73dd2531a7ee8b56d5e9" => :sierra
    sha256 "ec8cbcb077a91bbea28a48547886313ebf0d755de560ca39883764fac1ff0827" => :el_capitan
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
