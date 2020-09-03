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
    sha256 "f545f7ffd43e7d17746a0bf70a837405d71ea36469ab4a3555326094aabdafe9" => :catalina
    sha256 "2949f5126f17f08bd94ece8cf20fa6bd03ba77078d93d6332840956a7f4884a2" => :mojave
    sha256 "861cf617667287ae56ef4e4bef2af67493d82a2618c016620aa1ffd2e419e6e9" => :high_sierra
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
