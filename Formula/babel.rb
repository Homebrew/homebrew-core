require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.4.4.tgz"
  sha256 "aa6b4c8d5564e44f68e0ac1198e8a13ae641fcd9af3119e38538e34a691f1dbb"

  bottle do
    sha256 "700aa5420c7d1b736a331ce97bd97b96b3c4966e486cf14a75d07a2526b9cfd9" => :mojave
    sha256 "d24cfc3604d50be1c12f0d03096ab479f974a7e44c1557081a886df03c29b83e" => :high_sierra
    sha256 "35721d11e95cf2ff177607b1136e80ae58c1ab794d27aac838f646b9a3e620fa" => :sierra
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.4.4.tgz"
    sha256 "e6fb0fdbf80d37114f28c2bb8903b2d14e5d7c88ea19ba23e38a3d55e2dd13ee"
  end

  def install
    (buildpath/"node_modules/@babel/core").install resource("babel-core")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = resource("babel-core").version
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

    # Uncomment this for the next release,
    # see https://github.com/Homebrew/homebrew-core/pull/35304#issuecomment-449335627.
    # assert_equal version, resource("babel-core").version
  end
end
