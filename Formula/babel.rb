require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.7.7.tgz"
  sha256 "15f2266ab54addd1c18c88225cbb24d298720f46988bcb8a6ca2a46abdc89fa3"

  bottle do
    sha256 "083cedff488f8c12f899ac66d0a70ac0103c2d4a576c821e69664e04c23b5805" => :catalina
    sha256 "e7f0c9159140685381b8fe00ff84c9803a46c24e46d4c465693b15b34e9b8fea" => :mojave
    sha256 "6a52221d2fea7aa2abe0caaa031ec4d72a32aed27e072d54ba25e5d3daa6f0d0" => :high_sierra
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
