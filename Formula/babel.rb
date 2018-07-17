require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.26.0.tgz"
  sha256 "81ac501721ff18200581c58542fa6226986766c53be35ad8f921fabd47834d02"

  bottle do
    sha256 "283507db612687957e8855de052f97ebb8eafa9559f7edab627cb334012743c8" => :high_sierra
    sha256 "c4e2ca0a3d4f9d77b4d6c78c3982b333a8751fa36e5e0ceb506ef3d0e207c4f2" => :sierra
    sha256 "79ed0bda434eccc0d634407fcafebc419f529246472a807d16fb05739b9dc4f6" => :el_capitan
  end

  devel do
    url "https://registry.npmjs.org/babel-cli/-/babel-cli-7.0.0-alpha.12.tgz"
    sha256 "a81e2421486ca48d3961c4ab1fada8acd3bb3583ccfb28822cbb0b16a2635144"
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
