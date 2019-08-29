require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.2.5.tgz"
  sha256 "32a593f4f4e6c7463e57c65517a859f3b792cdc27068a89ee61dbd17bf882e7f"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "808e75808efd9246bc149f2703fe89ebaea430211257e2f6ea3b86a531a28bbb" => :mojave
    sha256 "c8d0c90703441cd975beb636588c9fa90fc487289a0bbce9e809daba1a4ee158" => :high_sierra
    sha256 "59d5eb5951f9540f72fa44e279defbf3e530c963920ce991946e2c9b03f8c97f" => :sierra
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
