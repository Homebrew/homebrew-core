require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.15.0.tgz"
  sha256 "ebd86ef86c1bf844a2f7abdf7cfd300dde29537dd427eed6049f059f3c31d0c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b866b374c35fb8784d16ba81566a32b11f9b4b1b5136d487dbd8e4f9d0714cb"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.14.8.tgz"
    sha256 "7765b33ba85c17654f9b554fd7b15f9cdd1a4f4cb063c637b41d60818639eab3"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
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
