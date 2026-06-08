class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.29.7.tgz"
  sha256 "7620855acd400b22c1972c23a5a60a9d3340c52b059df7f26ebaa50316d9f49d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff7b58ca6092542be1504cae6bf83f38269a91e74823503fb685087059961e95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43e912c9dd72fc91b565edf931bb22e2caa71de25a95e91be77bde75d8ddbb33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43e912c9dd72fc91b565edf931bb22e2caa71de25a95e91be77bde75d8ddbb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fd7a004223c2ae5da85720bec34472071c602fdd64ca94c33c6cd62ac8fec7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cd628c656de40fc66aefd0237f9ff2738adf2710a1f368d1796a54961f1576f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cd628c656de40fc66aefd0237f9ff2738adf2710a1f368d1796a54961f1576f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@babel/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end
