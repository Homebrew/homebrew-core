require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.0.0.tgz"
  sha256 "08dbc5415dc2de14994c96c5ae7190d4f4b01872629f6d8706d111d53b01c900"

  bottle do
    sha256 "8bef30b9b787762a98410e78ad4e7901a8e12eb3af780076cacf25c4c007cd2a" => :mojave
    sha256 "283507db612687957e8855de052f97ebb8eafa9559f7edab627cb334012743c8" => :high_sierra
    sha256 "c4e2ca0a3d4f9d77b4d6c78c3982b333a8751fa36e5e0ceb506ef3d0e207c4f2" => :sierra
    sha256 "79ed0bda434eccc0d634407fcafebc419f529246472a807d16fb05739b9dc4f6" => :el_capitan
  end

  depends_on "node"

  def install
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
