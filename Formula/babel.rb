require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.14.0.tgz"
  sha256 "41cff7659caf896fce5956bdcd96ec31a6e99cfbdbd8bff958f00366f352dc7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e42f3a2cc4ce8152fa7d656537ab16a5029cea910b848ee85629edcf4a9df051"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbcb12cfb38a94909b83d9c16aeffedde08f3dadd9c189a3bc26cbaf986c5a0c"
    sha256 cellar: :any_skip_relocation, catalina:      "b7a0a0ef11eb7536b96d09ffb320baac23921174ab1d3ef36713ac29b44fbfc4"
    sha256 cellar: :any_skip_relocation, mojave:        "4d407989c892dbea48bd2c18d7ac3b5187f5f896e1017fbc9edf93b47bb02bf5"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.13.16.tgz"
    sha256 "a48de92838d7c33e6b024ad313f0168ec62035be26f39ba4c42bd81108bda0f4"
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
