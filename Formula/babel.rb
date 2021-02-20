require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.17.tgz"
  sha256 "9642ed097cbd92a4d4b489a46887235a37302f9ceb027d726a92d5f9e4f3c565"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4c8957c7cea030aebd82b017c5423abfd1aaff8479502755fcb87d360529b9ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4d55262f9f18863c7ee218a5bb52179150a6795061d2b71a1d900dffaac35b9"
    sha256 cellar: :any_skip_relocation, catalina:      "705aa3def91bf049e8f8edcac5a601da220766904cd6e53413a13d561796f93e"
    sha256 cellar: :any_skip_relocation, mojave:        "6657dd05ae1f7ae5bb60faee28236a3fe6612b5754186d743f263b609da3b5c9"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.17.tgz"
    sha256 "e3ddb168928513d19642e328947ab1c2700d4d641666446743abada95c86b266"
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
