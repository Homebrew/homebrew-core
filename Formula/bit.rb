require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-13.0.0.tgz"
  sha256 "ae47000d205b1d7cfb8e82f684e6d2bcafb42094ac29f8512ba1c8958c1bdd7e"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "26bde0067e3a161d6b2585605369c29e461bab9cfbbaf1ed6aa16dad9e96f461" => :high_sierra
    sha256 "a69616fc21a5511a5effaafa77b7a7245aedaba56d6c28226da0be326e446cb8" => :sierra
    sha256 "dccb87a4f387c815984faed1e64f07fc9c9403c40d59f1a87b8efe21089ec393" => :el_capitan
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
