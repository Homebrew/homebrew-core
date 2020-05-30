require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.10.2.tgz"
  sha256 "837a58f4a1e85ea3d7902ddb92870c79a21d88408d3758fd0ce7fbf9182c8b40"

  bottle do
    sha256 "599629935d9ff42dcd6dc7f5af1fff3bb13c9ba311f741fd0f6285fc4450d57e" => :catalina
    sha256 "c676940a81f11bde9ed6e76d4b5353adc386cbee44cd1049dd988c94faeca660" => :mojave
    sha256 "2efee69255d25b9603545a47dfd03c10319b72e2e5ef383ed67a53e8a6ceb237" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.10.1.tgz"
    sha256 "1833d47e51a311b42667414855f96a0e9179f45a3935494cd9b0372e08f19f81"
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
