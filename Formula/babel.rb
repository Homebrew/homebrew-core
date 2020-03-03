require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.8.6.tgz"
  sha256 "2df1c0b546be24908cc60e4df52d51c726caf23986941e2a9997739f46e72ea0"

  bottle do
    sha256 "00c05ad04b5ca39c7b9778deae665b9c0412433500edf2aa7dabd0cc18038a3c" => :catalina
    sha256 "da1fdfca1beeb17ddce0d49d2f7a8d325a5997536adbe8a7e837d4c42c6cc702" => :mojave
    sha256 "89c74232851bb72edb317bb4fb399bb4b3ead7af57cba92dca8804fc5a247d27" => :high_sierra
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
