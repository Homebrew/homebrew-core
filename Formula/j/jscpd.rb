require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-4.0.4.tgz"
  sha256 "da55e87e3d0396a2507495df1026b242a0d58f00f8ced44526584b3f10c5a7e7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee652bd1f08396d4f26261bd9e791cd287480f1567c20a56a49a7ff2456f61e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee652bd1f08396d4f26261bd9e791cd287480f1567c20a56a49a7ff2456f61e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee652bd1f08396d4f26261bd9e791cd287480f1567c20a56a49a7ff2456f61e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dd07b2a8c6eb045cdd8e908ae27f1a81bc0065379ae127095222732befe3bd3"
    sha256 cellar: :any_skip_relocation, ventura:        "4dd07b2a8c6eb045cdd8e908ae27f1a81bc0065379ae127095222732befe3bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "4dd07b2a8c6eb045cdd8e908ae27f1a81bc0065379ae127095222732befe3bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a889a0cbdeb63579383e964efc8004df27f6947f81925e9711f11840cba80e"
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
