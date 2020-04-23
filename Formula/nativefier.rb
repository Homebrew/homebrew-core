require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-8.0.7.tgz"
  sha256 "14390eca2632a6bec498f9946a7cfb52abf052ab20e395b70edd054255fbd349"

  bottle do
    cellar :any_skip_relocation
    sha256 "276fc8ae49fbb6fe09843a08940228c33d6637b77d149ca04f53a871582bddf4" => :catalina
    sha256 "f23c07328aa1b743db3b12b0f00dae7c23f6c528952e248b54345ad0d328810b" => :mojave
    sha256 "806dd7134e33f031e182b2460c77a4c221eff488fe5f4fdcd15a6fbe44cbf13d" => :high_sierra
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
