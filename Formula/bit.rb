require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://www.bitsrc.io"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-0.12.13.tgz"
  sha256 "b74a3f4968591f726ed5d04e5448cc60084c8fab0bcf6dd2eb255d92d5aa6134"
  head "https://github.com/teambit/bit.git"

  bottle do
    sha256 "d58482e8c53cc09fa9703e435a7d21bdb3e9df03b99c195af8f619e67e54cd47" => :high_sierra
    sha256 "5976e0e804a82d02fe9591a9d80d2601caac8e6ee5d1658cad481ddd10774da2" => :sierra
    sha256 "025f3059ec853301ee9318ebc4922fb12e6488c898b6b98e5187e05d3b9379a6" => :el_capitan
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
