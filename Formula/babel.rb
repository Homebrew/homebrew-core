require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.0.0.tgz"
  sha256 "08dbc5415dc2de14994c96c5ae7190d4f4b01872629f6d8706d111d53b01c900"

  bottle do
    sha256 "8bef30b9b787762a98410e78ad4e7901a8e12eb3af780076cacf25c4c007cd2a" => :mojave
    sha256 "283507db612687957e8855de052f97ebb8eafa9559f7edab627cb334012743c8" => :high_sierra
    sha256 "c4e2ca0a3d4f9d77b4d6c78c3982b333a8751fa36e5e0ceb506ef3d0e207c4f2" => :sierra
    sha256 "79ed0bda434eccc0d634407fcafebc419f529246472a807d16fb05739b9dc4f6" => :el_capitan
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.0.0.tgz"
    sha256 "fb8f654c0d1fcc05d047301c5de81865c25c192ee4f51761e47277fc05cd8132"
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
