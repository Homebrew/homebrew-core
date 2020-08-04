require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.11.0.tgz"
  sha256 "6cc72544c0b6053a30007552d5a2dff02e301daa865c2ddc1e705c472ba7ee02"
  license "MIT"

  bottle do
    sha256 "cdb6e8a677abd51806f613bf3b0dea2f279a585c404b2394c2f67d3cf25579e0" => :catalina
    sha256 "eea97404fb7967b785bd125340335f4ba6deb1a5690fcd532444f2cb57b8f3c5" => :mojave
    sha256 "26d0080da12d5e4cbb005125391c2c345136581c4a982c2fa83bf71c45641fc7" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.10.5.tgz"
    sha256 "cebcdfc983c5dd3c3535bd6a0ea1f2f550cb3339d76284114d51c5b3cd80d5ce"
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
