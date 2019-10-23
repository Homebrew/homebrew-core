require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.4.2.tgz"
  sha256 "25f31ea097d21a9ef1b05791668e2acaf0ddd9d14560437cf50f3b6e8b568462"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6033a88d21383955d483a5d6cec1afde145a2353f0b439c0399c62e1a526c5c" => :catalina
    sha256 "91011cd148c1c302e406717f469f022b83f09bf2b738d54178503c4e4f1be241" => :mojave
    sha256 "bfa8e16c9659ccf7f74f5033a6731c596c6cb24437f0301d26f6dfeeba677d87" => :high_sierra
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
