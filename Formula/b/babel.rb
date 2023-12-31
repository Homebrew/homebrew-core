require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.7.tgz"
  sha256 "c922d195f87dcdc90bad1e35163def202b7a2016d660e41701560ee5687631ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9150a753964ded6336d924e3fd2dd72c1480216ed5ecc9b086c35bd670a8b4c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9150a753964ded6336d924e3fd2dd72c1480216ed5ecc9b086c35bd670a8b4c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9150a753964ded6336d924e3fd2dd72c1480216ed5ecc9b086c35bd670a8b4c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "9150a753964ded6336d924e3fd2dd72c1480216ed5ecc9b086c35bd670a8b4c4"
    sha256 cellar: :any_skip_relocation, ventura:        "9150a753964ded6336d924e3fd2dd72c1480216ed5ecc9b086c35bd670a8b4c4"
    sha256 cellar: :any_skip_relocation, monterey:       "9150a753964ded6336d924e3fd2dd72c1480216ed5ecc9b086c35bd670a8b4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f84e432b73ec93f878fe4a11d3038c8122f0f450a50a4135ff93be6216b6de1"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.4.tgz"
    sha256 "d68b7484904de1c6b3057ea473d39e9c0224c1f9300f73947985e19255f5e873"
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
