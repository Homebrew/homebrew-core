require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.10.3.tgz"
  sha256 "973e286b80ad4940eda7ea206f6b6dd759408c881493374f501a799cfcea24a9"

  bottle do
    sha256 "34e2756f5efb57510d986b8b1d270068056c568d984ecfcf9d96e5500a11fe60" => :catalina
    sha256 "a7cb2d34d33e0e2289197c88191961d6caa588b6dc8e54a0214e6adad1ded2b3" => :mojave
    sha256 "5cbcfd811c61a9a7dd37df3fa040986dbf55044c987005cd0265dba0e4535291" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.10.3.tgz"
    sha256 "c9a8a6b594cd093732c02c8ed8598b071240c1972204f6bf09fa915208b335d1"
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
