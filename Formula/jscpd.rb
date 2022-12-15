require "language/node"

class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-3.5.3.tgz"
  sha256 "901bf8f23f470bd15c38f4e2dd443f74b2682d11ad4525e8ea99a0e5246d5163"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78ddf9eaa6556bc17ae3b15237a88ac3ecbaab8afd720fef8955a6b93edc3d83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ddf9eaa6556bc17ae3b15237a88ac3ecbaab8afd720fef8955a6b93edc3d83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78ddf9eaa6556bc17ae3b15237a88ac3ecbaab8afd720fef8955a6b93edc3d83"
    sha256 cellar: :any_skip_relocation, ventura:        "d4a903e9d00cd989ae50217a6d0c07760b148c4a26007f29886a61e2b3b24e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "d4a903e9d00cd989ae50217a6d0c07760b148c4a26007f29886a61e2b3b24e4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4a903e9d00cd989ae50217a6d0c07760b148c4a26007f29886a61e2b3b24e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ddf9eaa6556bc17ae3b15237a88ac3ecbaab8afd720fef8955a6b93edc3d83"
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
