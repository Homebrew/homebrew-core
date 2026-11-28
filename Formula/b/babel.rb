class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-8.1.4.tgz"
  sha256 "1b406916ace5bbb57faa13fd0a6adc467bf09e1e138c656562bd6b822acc5ef4"
  license "MIT"

  bottle do
    manifest_sha256 "00ca3ce25ee3f6979df993de93c131449c1294b20c822ee5ec76cdfb665db7c4"
    sha256 cellar: :any_skip_relocation, all: "b9da15d4adcbe53fc0484d4750edfb2667697c9c91b3153bb15eed377f5fc733"
  end

  depends_on "node"

  allow_network_access! :build

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
