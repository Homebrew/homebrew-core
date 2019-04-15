require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.0.5.tgz"
  sha256 "1b925456d93012a2dbc79ba070b6806a7b8fd9275824ac0304f4faf7980fefc7"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "a30ebe9bba594175a3a03fc897e24342d9f111a5cb790e23cbfb0e54bb6ac895" => :mojave
    sha256 "55bd4f0637b5e6528f5930af4a9bea4d5beab96710d5c619319751b16508b69c" => :high_sierra
    sha256 "aa48b643d38aa1fb46c60e8762cc4e483c41a9060f4d173a0f57805e59d1c1a8" => :sierra
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
