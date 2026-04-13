class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.6.5.tgz"
  sha256 "8892df0f6932e3048cadd5ceedd6491be92ea23bc4ff291deafb81a50761c25b"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10609d2e7e67d30e3dfe7ce1e0eef086ba4ce3ae1c4a595d73d85315734a4434"
    sha256 cellar: :any,                 arm64_sequoia: "664e71063d4c656cfa35d33fbef1529938c6bfed1d2585865c63bc02f50b30ab"
    sha256 cellar: :any,                 arm64_sonoma:  "664e71063d4c656cfa35d33fbef1529938c6bfed1d2585865c63bc02f50b30ab"
    sha256 cellar: :any,                 sonoma:        "7f1a78d42e7ebcf33c815fa008537c64f040b7c4899ec44a29113dadc24e629f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20b4e7a5fc10c8ddf1fbeaae4fe2ae18ce433bd0a9d3cdc5152466bbc4c305b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e7b8234906989e02526dcfb3fcd0888276cea8566ddef891451e716555aa2f"
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
