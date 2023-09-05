require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-3.5.9.tgz"
  sha256 "e211ce3f662cb60b2f292bf35bcbd1509d91ccadeac496d0fdca11f5fedc8a4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ffdb869994ed687e2ba055b34db404126b4c2f2eb897e21144a06fe17f063ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ffdb869994ed687e2ba055b34db404126b4c2f2eb897e21144a06fe17f063ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ffdb869994ed687e2ba055b34db404126b4c2f2eb897e21144a06fe17f063ad"
    sha256 cellar: :any_skip_relocation, ventura:        "c8769fe5ac5ac82db915f871d0970dc003d62bde9edd9921db5632f9dc9f8ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "c8769fe5ac5ac82db915f871d0970dc003d62bde9edd9921db5632f9dc9f8ffa"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8769fe5ac5ac82db915f871d0970dc003d62bde9edd9921db5632f9dc9f8ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ffdb869994ed687e2ba055b34db404126b4c2f2eb897e21144a06fe17f063ad"
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
