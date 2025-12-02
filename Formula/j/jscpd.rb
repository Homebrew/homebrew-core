class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-4.0.5.tgz"
  sha256 "e284fc35166ee0cd5f0db3d5c15b8e9bf8bbc2914d498f361c65e259cf15ae67"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "8472b1d0c9e380790a51810478a6620ecd7dca78216743f8240331c12f8558b3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
