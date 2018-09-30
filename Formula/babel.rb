require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.1.2.tgz"
  sha256 "5718cca05492c71fe852ff61aae54e1dac0d15080d92c36e4fbbba1f5898b488"

  bottle do
    sha256 "1e2bd66b50516b91a8ac4a74d90f4b02035631ff2cf8a894a0628a4a8cdcf562" => :mojave
    sha256 "76bb0d58cf2403e39f695254df896481bf6eb5552e553e742f9c3758446b9290" => :high_sierra
    sha256 "6e9aea1b016b41e75486739ccafc0b5e627c58bc7c0902cac8fb9643758a3b9b" => :sierra
    sha256 "f60037a2c766012a20f2e2219f3ea110eb5f4bf76af2d6ee147a13e79e4c05a5" => :el_capitan
  end

  depends_on "node"

  resource "babel-core" do
    url "https://registry.npmjs.org/@babel/core/-/core-7.1.0.tgz"
    sha256 "c7e92941eeeae09167fe765b8ade41059329feaac998cda4aa41fc010a60b807"
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

    assert_equal version, resource("babel-core").version
  end
end
