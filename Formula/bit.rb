require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.2.4.tgz"
  sha256 "29f80b4a7ec4dd7ce52a62133ee40431c34648b90cf9821b68692a69b488de6a"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0c2ce8bfdf7ef76be02ec9892862ed52febd6f25d99a8872c7b8207bfb3a8ed" => :mojave
    sha256 "8c4df39063c92dd4125fb2f1c4d77e103a90ab1452e4a79a735dff1e9eb5a4b7" => :high_sierra
    sha256 "1afe3b19e36a9644d14e1f7cd39736487d2ba23ffb6d59972b64b580d120d193" => :sierra
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
