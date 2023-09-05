require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.22.15.tgz"
  sha256 "b3698ab0aabb49150fc6efae9c367f6d993a8fc80ebd9a44ecc7df5518bf30ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e0c23aa9dd36c74fd2bfad77c78592532153efe1b85bf0680d2e051ba6146f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0c23aa9dd36c74fd2bfad77c78592532153efe1b85bf0680d2e051ba6146f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e0c23aa9dd36c74fd2bfad77c78592532153efe1b85bf0680d2e051ba6146f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e0c23aa9dd36c74fd2bfad77c78592532153efe1b85bf0680d2e051ba6146f1"
    sha256 cellar: :any_skip_relocation, monterey:       "4e0c23aa9dd36c74fd2bfad77c78592532153efe1b85bf0680d2e051ba6146f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e0c23aa9dd36c74fd2bfad77c78592532153efe1b85bf0680d2e051ba6146f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe6bd6ed1a45a29b2f7e06731612f41d1051f2fa32d79c95167594616c3b685c"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.22.15.tgz"
    sha256 "6ac27dc7ff329c4c21813e71686734ce57721c8ef39b526a14617a4e1a6e7c1c"
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
