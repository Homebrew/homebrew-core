require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.11.4.tgz"
  sha256 "e471ae013e691c2d7088c4a001ef03c8b5cb85c9c2ea06f04768a05fa126d497"
  license "MIT"

  bottle do
    sha256 "d72b653c6ecf7f9bb8b417c6a1f4fd0e2d4317b35583b37f98c9ed5e7f7d31bf" => :catalina
    sha256 "c0a42c6cad3ddf48ef2ef89432449a5691fd9a8bdecb5a07cb482e1f35259def" => :mojave
    sha256 "ea91dbc9de6b896b12de4aac9db87821d00b8d77c3e64da1de0e4f2bd089db27" => :high_sierra
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
