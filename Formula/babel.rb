require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.5.5.tgz"
  sha256 "5943fff46bbfc2344e4a87e12223963439847b204ae5330aaaad7f7d2d947d18"

  bottle do
    sha256 "dd2869ee75ebb23278a2ab803da1f8dec1711fe33b1d091e4f285ce35cf61a21" => :mojave
    sha256 "78cba1c67f72a6e3283eb5abb75e23744df4e467ef075aa81f35b15643986c8c" => :high_sierra
    sha256 "0d87b588e8c40f0a89b9b4c5969f8987621a423d1e83bff61bebe892cbd0a9f4" => :sierra
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
