require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.25.7.tgz"
  sha256 "427c246c11d665ff20d1b9e7d8eedd54be3ac266f231e483db8ac11c430dfb20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74224a93a05f8957b4b455ebc339c367353491e3390d879123410d478dd15df8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
