require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.5.0.tgz"
  sha256 "7553359b069af04e376f42a96907a92c71009493090031518915e04ae8791ea4"

  bottle do
    sha256 "c497f17cab10cc0fd59e306a94579838b39c6a123175deb8e51cd6a9ea7888b7" => :mojave
    sha256 "3d6ffd2d9b3d9206616fbcecfaa430f33b3b7e2761d421ad3404375c63da6435" => :high_sierra
    sha256 "0ebb840ba73377b41160d808f8a5921aaaf1c10d86889712f182e987dff26359" => :sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.5.0.tgz"
    sha256 "4aef1a5285e29a1c0fb98231fd63496f7c6da7ee161b5b6d5c970f4a8fd3e122"
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
