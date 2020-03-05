require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.8.7.tgz"
  sha256 "e43c2bea6203f99e4964fc9bfac997d7b917fb43e24936db7dc425466c066ce0"

  bottle do
    sha256 "a8cce2b8d6fae4c2ca15f5b43fc341ee709d470b1d2b6ee2c1e9f51b57ebb811" => :catalina
    sha256 "cbe3831e019e6c42793d76aacd7ef53e6e8e05c1ab57659973c29f42fa16a7bb" => :mojave
    sha256 "2f0be893881e4262618b5ef50a9c4783862969421c75ea689e3e7321de7bc26a" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.8.4.tgz"
    sha256 "326e825e7aba32fc7d6f99152f5c8a821f215ff444ed54b48bdfefa1410c057a"
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
