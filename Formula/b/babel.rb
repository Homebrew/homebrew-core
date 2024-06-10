require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.7.tgz"
  sha256 "372976673f12462532d43e97d3e11bce6d2f2e66193c469a280766d3b1bd9c8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a97a5b225adf36646f8288ba3f261f6ec10afadd9de04600a507104791d1f71c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a97a5b225adf36646f8288ba3f261f6ec10afadd9de04600a507104791d1f71c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a97a5b225adf36646f8288ba3f261f6ec10afadd9de04600a507104791d1f71c"
    sha256 cellar: :any_skip_relocation, sonoma:         "66801ffd4db3f82ae55b004733b1c1b96d3c8409cb7d22ee072b34fd4536028d"
    sha256 cellar: :any_skip_relocation, ventura:        "66801ffd4db3f82ae55b004733b1c1b96d3c8409cb7d22ee072b34fd4536028d"
    sha256 cellar: :any_skip_relocation, monterey:       "f010f663753f7bc62b0e30508b33e5ca62775572c7093d99c1b114cfe4266397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cebabf9783e6b7c3c1d755c757e5d0ff0fb911557a35761a4f9d815834fd2de6"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.7.tgz"
    sha256 "ce6ec5fb622b845c8d29a39084e8e51e207e1b6586da232fc04922face6a24a7"
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
