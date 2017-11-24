require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.5.4.tgz"
  sha256 "0ff3abf439ebb339c39b87ff102b394297743c7169ff692eb0a448a46cef0be4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b97de8d91b300839fea83fbfaada5db37aea4722d158b2b3c191a26a3562d89" => :high_sierra
    sha256 "1afa8789194261b1922c877c176cac51c6d71bd66ea496e528b92726395fca23" => :sierra
    sha256 "6965e7be9e07d35dea867a324e8314082be150be52902ea1c479e9d732164e8f" => :el_capitan
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
