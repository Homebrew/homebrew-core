require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.23.0.tgz"
  sha256 "76cccec388472ff02274e27f9fa9657f5a88af5f2da02c9eebb6d92351d06c34"

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
