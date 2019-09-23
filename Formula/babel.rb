require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.6.2.tgz"
  sha256 "a2165319d6221b13cd707d1182fe51818e088f1b21b99011f12a2550463e5d5e"

  bottle do
    sha256 "fb13d4318d26c10fe5b0691e0691ee9ceab6298697f17a590379c5ab657debab" => :mojave
    sha256 "5b9c707dc4a4119210f2bd3c6fb7914f3b1b0747ec0dcd6bc15973b8f5332951" => :high_sierra
    sha256 "97e81463707dd95b9984ab732e7b35c95fd445fa5b6c3b12a01d8a0c0ad837ae" => :sierra
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
