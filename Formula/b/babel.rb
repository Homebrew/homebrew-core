require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.1.tgz"
  sha256 "defc92b869a08793e5ccac6b71323f32b42dbc6e992fb110a644345a19b6f615"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, ventura:        "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, monterey:       "8ef1db70f25fdca101e5ca54af8ed69487a1309f06613851141ae20f3dfad265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd20b81f2e174261198180a6a71969a6c0c9db170a9cea02482985ca6b3c1cbb"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.1.tgz"
    sha256 "462d441a9ddce9ab79e233647197d151e72a063e7fd2a323cba50c2d2f514884"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

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
