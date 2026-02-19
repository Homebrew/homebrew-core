class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.5.1.tgz"
  sha256 "f5e23aa0ea30707200e8d39f2bb5b3d35b1d0e965dc5a3a272ebba69a4612898"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "042b98c59deb361d9640d47b12b6befdb5b30385a985d25696528e23167ec344"
    sha256 cellar: :any,                 arm64_sequoia: "e98466753775bee8fc24b13ba0db501f02e92c37b3c771eee4d98f0b26218608"
    sha256 cellar: :any,                 arm64_sonoma:  "e98466753775bee8fc24b13ba0db501f02e92c37b3c771eee4d98f0b26218608"
    sha256 cellar: :any,                 sonoma:        "cf4ff24c2af6a13591b624a6f1de82f9afa9e6cdac32b81601be5f40074eee29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9c80a0375b6f9b114bad6d1626b74429b90c3fcb5599dcd0f5ca4f6a86d4e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55c3daf25fc9aab8d8681f5c967736ca3edae12da62c30ed37b63f845770c4d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
