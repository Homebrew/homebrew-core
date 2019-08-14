require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.2.4.tgz"
  sha256 "29f80b4a7ec4dd7ce52a62133ee40431c34648b90cf9821b68692a69b488de6a"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "2c71eb71558b9de6b875c5b1005c8a4f2529d389407884d74344615fdb9a8be7" => :mojave
    sha256 "c91e9364d8a3e9b048ebd6114de31e1d5a15168f5f03f2271f333aa1b1a072d9" => :high_sierra
    sha256 "255fb9cc0c907be3434a90ddd9b72fc515f87e2f2c656fae6ab97b85a1cfe8c5" => :sierra
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
