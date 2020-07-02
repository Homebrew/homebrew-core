require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.4.tgz"
  sha256 "5e27b6acf73667dd4a865cca6c5d61674a8a043424549e68ba7c52f49009887a"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "18a71387be68c7f440813843978c12367e2a1f3a0b1bafaefee2c586ab335861" => :catalina
    sha256 "e69afe4485e14108e15f2c521307f418e3b7b35e4d497427e8798f687afd9751" => :mojave
    sha256 "263a77fc0d1c0d54a845a30cd4f82dcddea65a6044256d0c42eeaaf1a72ce4bc" => :high_sierra
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
