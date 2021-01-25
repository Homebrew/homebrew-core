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
    sha256 "b3f552dcd31cd35f83aa44d2b40586608c552ba07e009b96da23a53a75e59bd8" => :big_sur
    sha256 "15f6a428bb5e6fb70f24fbdc29693451f19f6866f2b6b94cec0dfa5df4542bb0" => :arm64_big_sur
    sha256 "4f57b7ad8dde162ef1aa46bd14e3f659ab128a19760603193b9386cdfb8784a6" => :catalina
    sha256 "d84dd1108a58480e65f5e15515c87afbc588d05f959eee51cc20d108dcb4be0b" => :mojave
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
