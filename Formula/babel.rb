require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.6.2.tgz"
  sha256 "a2165319d6221b13cd707d1182fe51818e088f1b21b99011f12a2550463e5d5e"

  bottle do
    sha256 "7bebabbe8e0b06301839dad8267e8a1abfe4956782ac1d7d7d40b3978fc79f9f" => :mojave
    sha256 "6da23696430179947fd0a95a7f935483d8d786bc08ab4166bb67abbbcb93688b" => :high_sierra
    sha256 "a41d17406394848721c28ec3625d754a072f912792743532933ab81246f3b65f" => :sierra
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
