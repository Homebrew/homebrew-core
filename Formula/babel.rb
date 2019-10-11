require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.6.4.tgz"
  sha256 "b19527642ede6d98621e4f319448a5a78f2ad4a1cd825a8242d124ba6edbecd0"

  bottle do
    sha256 "fc03e0a6dbb8155b5d6fd34aa0eb905afb54325ff078261bce7e89e348d4b659" => :catalina
    sha256 "0ca72f3c6ec1f145e004f0244a87841340c3ca075fd668075adb8948d48cd756" => :mojave
    sha256 "58b96958f2c724caa58c3506382f92314ddf920d1c23e9976b799cb21cdc4058" => :high_sierra
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
