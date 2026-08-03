class Qrmaster < Formula
  desc "Generate QR codes from the terminal"
  homepage "https://www.qrmaster.net/developers"
  url "https://registry.npmjs.org/qrmaster-cli/-/qrmaster-cli-1.0.0.tgz"
  sha256 "ee899e248bdff544701ed138890e8e722563c9d6d2dd133dbf4bd87c6211d3d4"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = testpath("qrmaster-test.svg")
    system bin/"qrmaster", "https://www.qrmaster.net", "--output", output
    assert_predicate output, :exist?
    assert_match "<svg", output.read
  end
end
