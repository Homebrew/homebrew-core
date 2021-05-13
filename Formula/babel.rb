require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.14.2.tgz"
  sha256 "c0bf2dbc4714cdb6341001b120d4a99b6919ffe4960aa4fb9ffbcab8e1b11616"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17450dbe68d163d15a7724696b3a160d55fa67bb46dbb098f3fa098f7fdfb811"
    sha256 cellar: :any_skip_relocation, big_sur:       "a06fc96c6b5d0791b98e94f28d1eef5dbbe1be5817ab1e53bbc283392e99c0b2"
    sha256 cellar: :any_skip_relocation, catalina:      "a06fc96c6b5d0791b98e94f28d1eef5dbbe1be5817ab1e53bbc283392e99c0b2"
    sha256 cellar: :any_skip_relocation, mojave:        "a06fc96c6b5d0791b98e94f28d1eef5dbbe1be5817ab1e53bbc283392e99c0b2"
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
