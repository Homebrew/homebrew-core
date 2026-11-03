class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-8.1.0.tgz"
  sha256 "b7a1c775b4427d5023009da693c3176650dc42b52e6c6d9207befbe489845c6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "090a1a84098e6b1eb7072bdfbf73b7a8529f11fcf24c1a5779a37fcc17827a31"
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
