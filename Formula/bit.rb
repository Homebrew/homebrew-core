require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.1.2.tgz"
  sha256 "ec676d1308a05572e605358045dc4fcdb31f09bfcb0795740f231332adcb3848"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "d5424891a7c89e5d89268c3a62a02357f475f20754208fc768e517f0ccd06dd1" => :mojave
    sha256 "5d088d0d560ce98283552174314d33caaa527c1a6ea728fea0e0a957944a637b" => :high_sierra
    sha256 "18b61ccca1e13c99e6a71236d61663381135ab80df2957147a474ce2bd682cf5" => :sierra
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
