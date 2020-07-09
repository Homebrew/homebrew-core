require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.7.tgz"
  sha256 "04acda3824a0dc67e92e5fb6e9d65f28e7635148b9dc270297cc8ee3c64e106a"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "72702ab140594bae7869ca9c89059e924217420c952efb01c55c96a3cfe77137" => :catalina
    sha256 "66b877c03cd1fdab05f09f851084ff59ccf5807f15ab5ae99176641c6fdb3af8" => :mojave
    sha256 "532977b4b35d4e433bb1c53e8bcdea5912d49bdc4ce19a6362d7cdc7b4315f61" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
