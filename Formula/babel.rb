require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.10.4.tgz"
  sha256 "42c048a0ed1f597472f539153f339da0963324925c1131770caad9896577b1d6"

  bottle do
    sha256 "a91bf9298747d0b3a067094627f6ba514a5ba49813edd83e81e649609434f5ec" => :catalina
    sha256 "96141bc2ca574f0400c9f2c5ab1984e908efa3c827a8dfe5330d434fb732d7b8" => :mojave
    sha256 "bc5b854a5f7d651d3265f094ecbbfbfc695bfd0248207a689362a4421a0ba49c" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.10.4.tgz"
    sha256 "753506f198fda9a521b40d9ed45e6aa954a123f51e63b0f6f01c364c8acd9781"
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
