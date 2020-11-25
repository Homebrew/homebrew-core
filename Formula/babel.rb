require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.12.9.tgz"
  sha256 "5735f6d4256f0e81b5c3ba1c0a0df1f9364c9955987829a4c84d5f5a20074381"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "013d0dc952cf6355f2e1c63a63fc166821bb1dd71e5009136d17e7a5142adf98" => :big_sur
    sha256 "f9de5f6cdf8e3e8675a727cef44a69c079ef7b8c6b4cf75eb0f67412bbb7fbdf" => :catalina
    sha256 "0685d8046affd53a5042967d6f227c1473620464e78d4627baba197420d4d415" => :mojave
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.12.8.tgz"
    sha256 "bc72a36f5f1d3de643d5907194d38bf6f053e5b0b40272e37780eb0be132ec96"
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
