require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.0.1.tgz"
  sha256 "a8eaa6bfcb3ffc9d0af036e625bd1b3e51c9d406504c78327357ac423c9410ae"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "c66a2cdb385d575a16733075ebb071868e671ebd12e15e7c6496862dc11b900c" => :mojave
    sha256 "79b1d02ef074e9c851666d19f53bd65f4c3fce3be9f69b75facaf14944da7fd0" => :high_sierra
    sha256 "a17c101b765c55ff86da975acd2e848e620a9c15846fd2af032210c09c6d25db" => :sierra
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
