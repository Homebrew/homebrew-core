require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.6.3.tgz"
  sha256 "a7086bb8f5804cc4f82f1bb4631f0752e78061bfe47ea4ae9c5a227ca2879a35"

  bottle do
    sha256 "626f5843cd92e6d20df95693ca6f0de90bdb0b61ea0a7d7894a2828347d11595" => :catalina
    sha256 "bccaf08b1d2c7800a69b1ed379b3096034b29aed5603cb90c5467c76e555bc0e" => :mojave
    sha256 "f5f6ab76389d765e8e884660f8977a91592cfc749b76084d8c7e2cf9472aef9f" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.6.3.tgz"
    sha256 "ff52b092033e1e1e68d6feccddf8fc544babcb2fbde253d1ca7bde0d29816411"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
