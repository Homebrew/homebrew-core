require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.12.tgz"
  sha256 "2581803cd01fc83ca29ddd3bc39093264ccafc81a7533fdd5c58300079343b3f"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "9f078529bd07e87026c1782f91de467d6c0c937283affd603b4dfb87f933fd11" => :high_sierra
    sha256 "2b9d357254803edf067103631cb8d72eb3cb8586c0c9a7aeb5766452f093f2c2" => :sierra
    sha256 "5b4db53bf940ccd465d8bfa4475349850a908868186f4234cf312c03990bd4f2" => :el_capitan
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
