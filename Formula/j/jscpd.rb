require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-3.5.10.tgz"
  sha256 "6f42fba5d2935f5068af0798545bb60c4bde5b64346061e7286e51cfe703de0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6209e7fd09c013f4700d4c739f3b015dfb52177c8560df5de25af4fbd993a6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e51ad448745846c94b3c51ec46d753c43059b732cf9e1fb94971d5c3a0e32bc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e51ad448745846c94b3c51ec46d753c43059b732cf9e1fb94971d5c3a0e32bc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e51ad448745846c94b3c51ec46d753c43059b732cf9e1fb94971d5c3a0e32bc5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7069823801be847f49997df8f3c46fb43302a598eb2b66c87c4f12010ef294b"
    sha256 cellar: :any_skip_relocation, ventura:        "423d5ece361e23e2c768e51265446c3d5d394193284cde28eac3e3eb5374391a"
    sha256 cellar: :any_skip_relocation, monterey:       "423d5ece361e23e2c768e51265446c3d5d394193284cde28eac3e3eb5374391a"
    sha256 cellar: :any_skip_relocation, big_sur:        "423d5ece361e23e2c768e51265446c3d5d394193284cde28eac3e3eb5374391a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e51ad448745846c94b3c51ec46d753c43059b732cf9e1fb94971d5c3a0e32bc5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.js"
    test_file2 = testpath/"test2.js"
    test_file.write <<~EOS
      console.log("Hello, world!");
    EOS
    test_file2.write <<~EOS
      console.log("Hello, brewtest!");
    EOS

    output = shell_output("#{bin}/jscpd --min-lines 1 #{testpath}/*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}/jscpd --version")
  end
end
