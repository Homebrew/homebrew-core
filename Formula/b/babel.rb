class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.28.0.tgz"
  sha256 "35902327eac780ffb33f30ce41b68aa8eb5b2314aabe60c3227341d7d3a4cc0b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81184998b87067419e9d3b46f4ac0333803182a40c52c397da1dd603f90a3358"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end
