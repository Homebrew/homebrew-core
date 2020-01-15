require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.8.3.tgz"
  sha256 "904f21b663d036a366cde50d03359da93c3e1754d97d3a27081854af8dcd45c6"

  bottle do
    sha256 "6746fa28c2872f910a8e86e42ae5eee41eb3f401ec8450ac8a6c6ca52a4f59d5" => :catalina
    sha256 "20e2bf439828ebbdabebd352ccf569695c127c8104fdee6c7767a11b6b054b9e" => :mojave
    sha256 "79cb578c8a18afb119dc8e6b4b0b3eb397afd2835ed261af0bb3df6a634b2eb5" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.7.7.tgz"
    sha256 "d28508eba145aae23b9e0732b8a473a08ba3489a7524a0c35281c2936c5ed1e0"
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
