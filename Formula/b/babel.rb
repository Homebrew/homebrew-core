class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.28.3.tgz"
  sha256 "7166334788706818cba54d9f4daca3d1f45859e5586dc8a155f187a1ec6d62eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7bba0de148f0f36c7bcb50a74f05b66068249554645dab0e558822278ae6476"
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
