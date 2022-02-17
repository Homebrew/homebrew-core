require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.17.5.tgz"
  sha256 "77a0a543bb1dedd6fa05cdf00e639bf9d89f2a9ea4e274c479821bf254b1a862"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6684889c56eb62442c8621207af7de54a3eb53d95c2c3633dd798b7bf377ca1a"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.17.3.tgz"
    sha256 "4c39832b766580ebff2199961f9ccba80c742edd0ce9502f7b1533240707e823"
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
