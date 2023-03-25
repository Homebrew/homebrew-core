require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-3.5.4.tgz"
  sha256 "3a6582eda92d2e25994a8194762fbf0c3c26a089034b6edfcadfffa655531399"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d18d3e9a01446a19dc0737f7df161b008dd15d4e1cd56ebbcec4bbb00dcbcd5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d18d3e9a01446a19dc0737f7df161b008dd15d4e1cd56ebbcec4bbb00dcbcd5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d18d3e9a01446a19dc0737f7df161b008dd15d4e1cd56ebbcec4bbb00dcbcd5f"
    sha256 cellar: :any_skip_relocation, ventura:        "15386a4f78db60f1ce996bbadfa4719e8d19d0cc688bff5f5de6923c35f25a89"
    sha256 cellar: :any_skip_relocation, monterey:       "15386a4f78db60f1ce996bbadfa4719e8d19d0cc688bff5f5de6923c35f25a89"
    sha256 cellar: :any_skip_relocation, big_sur:        "15386a4f78db60f1ce996bbadfa4719e8d19d0cc688bff5f5de6923c35f25a89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d18d3e9a01446a19dc0737f7df161b008dd15d4e1cd56ebbcec4bbb00dcbcd5f"
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
