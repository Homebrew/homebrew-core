require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.10.tgz"
  sha256 "6bb4e8e11b2b95e0dbf77fd916fa90e0128b09dcf0008dec91223c8a53075a2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ba3ed3893347805b4f4ced9700091fda3fa902149b71ba1286f8715bacddcde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ba3ed3893347805b4f4ced9700091fda3fa902149b71ba1286f8715bacddcde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ba3ed3893347805b4f4ced9700091fda3fa902149b71ba1286f8715bacddcde"
    sha256 cellar: :any_skip_relocation, ventura:        "5ba3ed3893347805b4f4ced9700091fda3fa902149b71ba1286f8715bacddcde"
    sha256 cellar: :any_skip_relocation, monterey:       "5ba3ed3893347805b4f4ced9700091fda3fa902149b71ba1286f8715bacddcde"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ba3ed3893347805b4f4ced9700091fda3fa902149b71ba1286f8715bacddcde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79cbe864b82e9378684a8f44ca62417d8dc551593a64e4eb1792cb812f5346c4"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.10.tgz"
    sha256 "7234890638723e050b6398f31acd75f07454471505856249ad4a728c1738e2c2"
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
