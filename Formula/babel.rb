require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.6.0.tgz"
  sha256 "b00e8114526e29be8a7c1db6f538043ed47903a7e4d3c2dedf84799b441f03ac"

  bottle do
    sha256 "76ee6578b9604bfa056a3aff616dc34b103f0ace58ffe46f1aac1ee655be4c87" => :mojave
    sha256 "dd04dc75a26dfde869118e890d56d002144408aa4bee1efe2f09308090b8d974" => :high_sierra
    sha256 "fed17956a02a447cde098c95a7929dec48908442b1fe12abfd507f50f02e6d8d" => :sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.5.5.tgz"
    sha256 "fa78e5e4ebef7eccb0274fed059b8fea80921018368bd5b8d17904b5a8a26f4f"
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
