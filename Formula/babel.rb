require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.9.0.tgz"
  sha256 "8490214c5335651254d42edec53eae0441633b531f3b9fbe03bb0545065e32c6"

  bottle do
    sha256 "1a5a985a9ec01bc5b3a917fc840b4abcc43d73099f9e2587f2c18c001519c5e6" => :catalina
    sha256 "aea88eec45e5f99d1e79cdd24ad9af9d51568417ef3e7c471fe3e8d282e516ef" => :mojave
    sha256 "48434e27fd11c8a229b662224e4e81925162385e8d1ac8f127347b8657be6bb8" => :high_sierra
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
