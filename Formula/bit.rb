require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.0.0.tgz"
  sha256 "9f2a186562d08d9987c6c9b83274dac84cae16168cb266479f1f99ad20947d9e"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "42420a8e139f35c5ce18013429dc96a7e8515c06af7ac8c33c479b6144975605" => :mojave
    sha256 "a34e6272d52e85f801f622e2d8ff29c61b9720baf2452ef806b1e51d05cfa8dc" => :high_sierra
    sha256 "bdbca7d3cb50604dadd11fadbdb5045208b946404a8c4a0f6a1a44a2c942e3e2" => :sierra
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
