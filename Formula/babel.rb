require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.19.3.tgz"
  sha256 "354c830e3f86bbf0711bc4346c6bedac1540d7ca705910bc2cba1e6a1acafcdf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b73bad5b901717c921d1fd97c4c116968cd25ebe9cb5fbc6980e3c453a7dc620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b73bad5b901717c921d1fd97c4c116968cd25ebe9cb5fbc6980e3c453a7dc620"
    sha256 cellar: :any_skip_relocation, monterey:       "8171b05dc83a6d695b87a16bedc43c739f796de0d44e445cc6bbc7a1ce55d6d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8171b05dc83a6d695b87a16bedc43c739f796de0d44e445cc6bbc7a1ce55d6d0"
    sha256 cellar: :any_skip_relocation, catalina:       "8171b05dc83a6d695b87a16bedc43c739f796de0d44e445cc6bbc7a1ce55d6d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b73bad5b901717c921d1fd97c4c116968cd25ebe9cb5fbc6980e3c453a7dc620"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.18.10.tgz"
    sha256 "9bda888e2b4feb37e343657b2a7eff5e0480c8fc1713d8919b368a24c8164f69"
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
