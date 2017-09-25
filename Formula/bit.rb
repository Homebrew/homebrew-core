require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.10.7.tgz"
  sha256 "d033b76974be7103933abe1fc937297d29c19aa1cdabbba8d5032ebd9d4f72f0"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afc34fb0172b2eb1a579b4334a084c0df77b7ad6977a11d3641a72dca6211487" => :high_sierra
    sha256 "67a6a52d87f99c90171b82f1f10c784a686969a30366e5c119d6b450a04271bf" => :sierra
    sha256 "67a6a52d87f99c90171b82f1f10c784a686969a30366e5c119d6b450a04271bf" => :el_capitan
    sha256 "67a6a52d87f99c90171b82f1f10c784a686969a30366e5c119d6b450a04271bf" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
