require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.2.3.tgz"
  sha256 "c11ee392ed2d7ee30126028c5daccc5d98ae6ba4753ae693114591101c98c144"

  bottle do
    sha256 "9bebd39e19923716ca500d25cd0e84158ff8aeb1f2700f23a92e656e881207de" => :mojave
    sha256 "4f0ed05136e92d8bc9f9944705beaa859ec985174f02db57e5985d226af3c5ec" => :high_sierra
    sha256 "7b4aac9aaa968f5eb947f95567aeaebc366993bb6b7d785808fd84ffe1c1a028" => :sierra
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.2.0.tgz"
    sha256 "7f60c1a95f03c86b0e9329989045f460c3fb86ce6d4f545327b6091f1ca37eae"
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

    assert_equal version, resource("babel-core").version
  end
end
