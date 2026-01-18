class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.28.6.tgz"
  sha256 "f615e694e3af72ae0f522d765b905454921ec4e81eb63c24b17b963a41463390"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e563c3f414727bb3314b4c267eb1fb1915cde14ec306164ab198e965410a69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f603167682e3bb0cee84a946ca2d77b9d9203bd6524fb7bb0dd4ea4bca147a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f603167682e3bb0cee84a946ca2d77b9d9203bd6524fb7bb0dd4ea4bca147a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71fc98bf8e6eb16bcd8104124e39221f5c4362c0fc8d32670466fe848007443"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30a0e767aed7a9f954a1ffbf422bd9758a2dd81701acd31ba3257b2689aeebcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30a0e767aed7a9f954a1ffbf422bd9758a2dd81701acd31ba3257b2689aeebcc"
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
