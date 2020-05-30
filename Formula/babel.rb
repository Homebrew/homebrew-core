require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.10.1.tgz"
  sha256 "34b7f74ea302bde08892b81cf70d61c420aa0c20ccb149a886d9e6e7d143623e"

  bottle do
    sha256 "76ab640f5ea3b08ff5ed618b9e254a63b7d66adebdbef30626710f2d462156e0" => :catalina
    sha256 "186c556f3899018d69bf726bc47c41aa082646e4a84404d0651c2eb14688e10b" => :mojave
    sha256 "3a60e8f574d9f10c69fe82e126e85a7850552567c4053179ab67cd74ec39d7c0" => :high_sierra
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.8.4.tgz"
    sha256 "326e825e7aba32fc7d6f99152f5c8a821f215ff444ed54b48bdfefa1410c057a"
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
