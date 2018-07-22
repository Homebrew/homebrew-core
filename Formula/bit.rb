require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-13.0.3.tgz"
  sha256 "8534253c8b56f3a1ed381f088f42a86cd9ffaaac4eda00805193eef863f66226"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "1bcd445841a5fa8b1667853c57268c9ac404d920880ba1e7ef6ef47c50d69962" => :high_sierra
    sha256 "2c76fbcbb285e256b0143f65fe91a08a67e5eeb1192cd35581017760fe2d36bb" => :sierra
    sha256 "40b50d474570c7add725a71e9785fc36d2420995dd1a2a7d1ab713616624868e" => :el_capitan
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
