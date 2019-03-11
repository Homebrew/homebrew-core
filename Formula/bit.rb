require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.0.2.tgz"
  sha256 "fd7c3b444da1888d3113a8e087409c9e0b946d1fea54b2ea9fe3a4914ce51d5b"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "a3a4f4c0768532dfa79b0520332778d791f7533f851f018e9aa5d76dc9447e5f" => :mojave
    sha256 "07eac8096322205b9def0465c6deb1d570815a6f9daed7508047e2f499dbd4c1" => :high_sierra
    sha256 "a4bd93e273518f45b189767d10ca85f7621ac3c4065e20b63ec06b16bab61e9e" => :sierra
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
