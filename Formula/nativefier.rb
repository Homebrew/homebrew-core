require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.5.4.tgz"
  sha256 "0ff3abf439ebb339c39b87ff102b394297743c7169ff692eb0a448a46cef0be4"

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
