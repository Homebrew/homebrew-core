require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.10.tgz"
  sha256 "e32ad338ccc97c8110bb3bd2954e37a8fe60d80c1559161ba6b0a5ad4595616a"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "155b88616532d7f7c3f8716bf5f9d983783ee0f904ea3f4d3943fd73a38ce5c3" => :high_sierra
    sha256 "3c13cde52f6e3fb5fcba3f3410c362d1e774c841eae62ef82b3db06824ed01ea" => :sierra
    sha256 "75ad4ba4b43cc9e612e691cb2a56d27557a02baa57b070bc0a160f2c42975c2c" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
