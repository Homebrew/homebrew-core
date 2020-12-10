require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.10.tgz"
  sha256 "77478bc9855682349a40ecc3ff4f00329f47989dcca3f6379a7585201fecb6dd"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "415866851adc5f35702eb931cbf56601d2626e4fb9ff5aec23ff4baad1dd6a9b" => :big_sur
    sha256 "1153bde1ce1b1078d99c94505315e0b67ca498be667d1b81cd8e8b8374b03124" => :catalina
    sha256 "aaeba5292a84bbf7e36fed50a579f73ea74bfa2ecd9b14fd88cf7fc86d1177b3" => :mojave
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.10.tgz"
    sha256 "37dce2d25c075206996913da0dab9970d420bb171f83f495ccbeba2161e88dab"
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
