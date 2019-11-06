require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.7.0.tgz"
  sha256 "6532df4e23078d44a3cef4ec666d62a5fec76637f85d3ed36be0b5f85775d935"

  bottle do
    sha256 "339dfa499e9536b0b7933ef41a31e79e494cafcc148c6ea66e5faee0b941fcee" => :catalina
    sha256 "d2093ce9db3278862a576cc23781ea3657560ea3fc4817bdf893cb0cfa9a325f" => :mojave
    sha256 "85cb8d5b9d4b2df18b9e509a2ee69f5035d532b41ca7c495f5d1f750dd88994b" => :high_sierra
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
