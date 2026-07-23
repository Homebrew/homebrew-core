class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.1.0.tgz"
  sha256 "7a8378c4a6e4893fbb0237d6b85dbd85150d5e474e7c3aa1d7b6665948c44173"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d8caf07512781aba38993bccd69f42e26e5864612c4b22b8c4c9b7f8876b1c0"
    sha256 cellar: :any,                 arm64_sequoia: "6d8caf07512781aba38993bccd69f42e26e5864612c4b22b8c4c9b7f8876b1c0"
    sha256 cellar: :any,                 arm64_sonoma:  "6d8caf07512781aba38993bccd69f42e26e5864612c4b22b8c4c9b7f8876b1c0"
    sha256 cellar: :any,                 sonoma:        "bb3a85d6a8abbd4b4f96b05939f2d72475cfd8056631c8719ac9b90d1b95d0eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b201ef76ac9feef7b83fbc49409cfc65a8d0553d4d05e6312c3ed32e0610a01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcdb8f217b6564a58076f465fcb5f6c5dc2f4c357d274f6ee1579e426ea7152a"
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
