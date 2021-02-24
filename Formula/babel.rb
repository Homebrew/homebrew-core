require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.13.1.tgz"
  sha256 "bba8ef486e7624e9708e06b64076baf2c5275ccdd1e43b155f7e24e6491ba961"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e6902958d3526bba159263705f85001b512d85cca3c628a6a86cad760f72a0f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0625a43b52a9843b4fc62d8fe20bf9469a9abab10ea2e5fc328f7aa477e7ebc"
    sha256 cellar: :any_skip_relocation, catalina:      "af3ae2aad7994f95fbfb17889d32b27d60535c88d7cbc8eef68c4384a30edb34"
    sha256 cellar: :any_skip_relocation, mojave:        "27288d00c0c90db4991d3210267dbe6753f15238aff50a0555d63e6b23be821d"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.13.0.tgz"
    sha256 "fc2d9effdf94122f84f3f0bc6f70e8b4b9f386ef259184da00d7d903bc98188f"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundleDependencies"] = ["@babel/core"]
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
