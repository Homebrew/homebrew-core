require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-7.6.2.tgz"
  sha256 "c4539f09dde983f5b268c1c0603c84d085a19205902a75489bd9d5c38cbe3f26"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fb0e76b4775ea1bbabfa37175a4529df76f4e9b567dc6eb84305c956a44c295" => :high_sierra
    sha256 "83d06a8a51abee405148bf045ab2e5b4ad7706c1448615b32fa012a0b234e107" => :sierra
    sha256 "88a668dda678d79375797edf831040b8360d670686e178d0508aadf5781080f1" => :el_capitan
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
