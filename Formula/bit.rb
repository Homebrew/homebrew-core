require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-13.0.2.tgz"
  sha256 "dd52076c64b0b185ca4a4fffb2d7f649495bbf2e7fd933ebe40d06ca6f3f409a"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "3f7065917b56c4e1ec826e385dbf2466b15388f2c9a3deecf0a903aa77be01e8" => :high_sierra
    sha256 "e9c9d7280ed016aa2014febf3c2ec1878974d1a98a6fea667e9daf2eaa4b2fa5" => :sierra
    sha256 "5cb57359aba2a8e5f6c156acc8041165fbca485a01bbe273e99206077d9461d2" => :el_capitan
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
