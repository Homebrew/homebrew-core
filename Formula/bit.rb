require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.1.3.tgz"
  sha256 "fa174e53392256d4c2a84427bf4385601afe6f6a0bf6680b60ed6a77d85ea7b8"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "04c98812e8b55a44e16ab055283f9d4b627b4076ed5b0b922627da34540971b8" => :mojave
    sha256 "4a81ce4c5db838a1f3ea6de5e0e3af0334d2b5e35893e0f014c8a762387d42cb" => :high_sierra
    sha256 "602aac5e6f0b355c3ca78c741934f1232b4a3125438ecd24bb920f0648d87d4f" => :sierra
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
