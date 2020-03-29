require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.9.0.tgz"
  sha256 "8490214c5335651254d42edec53eae0441633b531f3b9fbe03bb0545065e32c6"

  bottle do
    sha256 "cfa4166aa99b7c60460d9c7807bcfd90850c23b95acc05d05e1e0e2b239ca999" => :catalina
    sha256 "3534e620e87db348a7a898e9aad067393c6b8009fa04c21f173d002576616c39" => :mojave
    sha256 "97643655911d9843f3c3682a407aabb8dc32e8cfae400799199e8bceccfcce3b" => :high_sierra
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
