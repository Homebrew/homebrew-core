require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.11.6.tgz"
  sha256 "4ce5e610252196c5c8f406e04510edf946bfa4d18b0454bd3b118a73fc6a01fc"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "57ef34b67255a4b551a96db8cf39edf7a41de72c8672af87334e1a6591b26de4" => :catalina
    sha256 "c6bb760bd560268e77b847acfeab100d84b105c7bf356b178ea5a9204b325b98" => :mojave
    sha256 "1730a4b800e14842c4756c5cbd97270a8d82f552fc13575d4de1cde674d509c2" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.11.5.tgz"
    sha256 "753dac0c168274369d18cb7c2d90326173aa15639aa843d81b29ca2ac64926e5"
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
