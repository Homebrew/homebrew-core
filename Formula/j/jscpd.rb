class Jscpd < Formula
  desc "Copy/paste detector for programming source code"
  homepage "https://github.com/kucherenko/jscpd"
  url "https://registry.npmjs.org/jscpd/-/jscpd-4.0.5.tgz"
  sha256 "e284fc35166ee0cd5f0db3d5c15b8e9bf8bbc2914d498f361c65e259cf15ae67"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e98285802ac160668e23cd901cec1b45ff0d66fbbaa7e9e4ea1798b317dcf180"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "541ad78931d710438b9489495ff9c534354286e397e20b9c5998af960512d04c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "541ad78931d710438b9489495ff9c534354286e397e20b9c5998af960512d04c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541ad78931d710438b9489495ff9c534354286e397e20b9c5998af960512d04c"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e76cf1e82fe5ae1995207ff03b8ef0856452f10febcb7b00305897b8e20bc8a"
    sha256 cellar: :any_skip_relocation, ventura:        "2e76cf1e82fe5ae1995207ff03b8ef0856452f10febcb7b00305897b8e20bc8a"
    sha256 cellar: :any_skip_relocation, monterey:       "2e76cf1e82fe5ae1995207ff03b8ef0856452f10febcb7b00305897b8e20bc8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "25641d2af5043374c2dc7fe30d38290923e380fe2673219e8d9320afa3d87c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3659994d220039eff175732b7ba2d5cd3c0213e6ff2d4129e2b9b3b93611efe1"
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
