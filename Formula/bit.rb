require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.0.tgz"
  sha256 "aed1824e876213840afef1177d99bdcd74760afac8d9f747f33954627af04813"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "47b8807d3c63b9f37bf0f850e488a130da6b422bad91d2374ca2fdcf21bf7c68" => :high_sierra
    sha256 "3c60d4a06d976ebe3938a7af44cca27e2f5ffba0b7fa216ab11deeaf0511a3d4" => :sierra
    sha256 "265ea487213a47abdc8a22241112161c482d3c041928ab1454186514dfc41d95" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "successfully initialized an empty bit scope.\n",
                 shell_output("#{bin}/bit init --skip-update")
  end
end
