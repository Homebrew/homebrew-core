require "language/node"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/babel-cli/-/babel-cli-6.24.1.tgz"
  sha256 "d69a00bdb4f35184cda1f5bfe8075cd4d569600b8e61d864d1f08e360367933b"

  bottle do
    rebuild 1
    sha256 "fa63837b3f1351ef2d0307ab556e40bbd91c1bc383c6d4ada3a072471cb01b40" => :high_sierra
    sha256 "102dda22f4541c686da92112bf3b7c91da7ace61e04633d19a9874ee6c3d8935" => :sierra
    sha256 "7dde27b4e0d9901fa2b2f3051fbe5b11baa3635e7bfac15ae4a0690e0270f067" => :el_capitan
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
