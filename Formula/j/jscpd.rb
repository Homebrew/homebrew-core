class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-4.2.4.tgz"
  sha256 "749cbd0bc12b47849f7eeeb3c47bb6b75e7dbe207f5a09fde5dfa994bdadf4d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb6d6b0afbb9e63ee593cae0786759bcfeb3493c9c1136bd1c346fb39fe3c14f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
