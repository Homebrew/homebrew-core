class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-8.0.1.tgz"
  sha256 "5cc94939d72c31145a4a14b20c4e6d51af94d26e4e49d95137a661fe60725cda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf05542675e893c78f9423c578204c3a495716f60654cda63ea5e1be9568b6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84136e31faf8aa5b4d9c1572fc5dd23a0f718eeadf8aa00a8c0e4b318db46a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d84136e31faf8aa5b4d9c1572fc5dd23a0f718eeadf8aa00a8c0e4b318db46a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f83b99f1a1c1aa8d57384cada0b857d54e0d12dfe6df5d669cb6c2ee68f6ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9023b7be6d8d2047e6b566326e51f702231a875f2a61f5c870d34fb22262b33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9023b7be6d8d2047e6b566326e51f702231a875f2a61f5c870d34fb22262b33b"
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
