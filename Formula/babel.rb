require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.17.7.tgz"
  sha256 "1c9b766a346bb8885410896b3802f154f06ac828764a652456af8c6d1c2c55e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6a687f5539c0d37d2fb93eac4b7b858b7a0492aed55361fe33cd9e6e78224e7c"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.17.6.tgz"
    sha256 "a408696976eae98c4fc52a1e2b83e30970513a6d0f8eeafcec5dc6e978a8db5e"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

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
