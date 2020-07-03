require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.4.tgz"
  sha256 "5e27b6acf73667dd4a865cca6c5d61674a8a043424549e68ba7c52f49009887a"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "ae3d77a938093a5eb0d8a6c890b2c551e7c3df843501e5152d56d4efcf8b04f8" => :catalina
    sha256 "16427042930e6f588c1bf85f52e783e5a1ac8d8ccdee9f9145770843e405f1e1" => :mojave
    sha256 "b8730726ca194285b0a8d4142f931c649596dbafbbdeb53c4a4b34be85252602" => :high_sierra
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
