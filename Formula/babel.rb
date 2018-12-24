require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.2.3.tgz"
  sha256 "c11ee392ed2d7ee30126028c5daccc5d98ae6ba4753ae693114591101c98c144"

  bottle do
    sha256 "819911f333897be72ef27919d33666bdf304f7e427659254bf8c40c8546937ad" => :mojave
    sha256 "74246882b2f2e75c67d895406a9d6a3ce04a7ad554787503f73264e1b4c60650" => :high_sierra
    sha256 "ae17cdae5cdb4358c96bda4ebf76a34d2f429e0676219647dfd9d3c75039f4dd" => :sierra
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.2.2.tgz"
    sha256 "b632e5a565b000645d7bc0010331773481cc5dee7d4360360dccaa9e51c4785e"
  end

  def install
    (buildpath/"node_modules/@babel/core").install resource("babel-core")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = resource("babel-core").version
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

    # Uncomment this for the next release,
    # see https://github.com/Homebrew/homebrew-core/pull/35304#issuecomment-449335627.
    # assert_equal version, resource("babel-core").version
  end
end
