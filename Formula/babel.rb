require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.7.4.tgz"
  sha256 "3bb9a1d79c68a0c1c41885b86471d306b99efefabb2def80ea3a511d3476f048"

  bottle do
    sha256 "ca4574c264ad3c4a2f563ea8680c9b0b16114e90c729d6e2adb1dfede3ea7fc7" => :catalina
    sha256 "bdd49169c8071c88a1cf4258cc65528ae10a77a42bc5199470a0185fc186f240" => :mojave
    sha256 "c2a7a3b922812528e778bb77706a6fb7a77ea1398853804d8a391ab248babc14" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.7.4.tgz"
    sha256 "07b17689c27908ff2e64cfb0502e79aa4425b79bcdc740e029897a20d4f4a9a7"
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
