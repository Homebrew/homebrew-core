require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.24.1.tgz"
  sha256 "d69a00bdb4f35184cda1f5bfe8075cd4d569600b8e61d864d1f08e360367933b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7e63adb35ef55305e100deeba0a70531840ecec7fd36621b87c972e8569769d" => :sierra
    sha256 "f40c7bde8a92aa6c4379e4fc2fb57ae18ba938d32e6946f7df31e89be9551f82" => :el_capitan
    sha256 "fa8e7ac3d0ad66013745fe499bec73982c3cd4a18a24fdca707ecc42d4a5d821" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<-EOS.undent
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert File.exist?("script-compiled.js"), "script-compiled.js was not generated"
  end
end
