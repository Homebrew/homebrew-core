class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-22.7.1.tgz"
  sha256 "f2f3f2c5a3078ef7e5b3872288896ec242b9f5d3ceffb4fc7dde1271988e800e"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0ae03d6abe996d70166f8dada0d35acc2ff9e08d637fc12ab92cfbc1cf0f85ca"
    sha256 cellar: :any,                 arm64_sequoia: "0761951814ef860c43019b3b66929772095f279c0c139b727ad432330df69584"
    sha256 cellar: :any,                 arm64_sonoma:  "0761951814ef860c43019b3b66929772095f279c0c139b727ad432330df69584"
    sha256 cellar: :any,                 sonoma:        "1f7ad4efdd147c6453fbf5afd36e9ea17ca906afcdf1059cdea639b9ed990e80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e3b8f015ea901f93a433c3ea1ab6d018543f36f8a73fb7a03948503866ee825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8749e92849d9944b7f33b36f564c6f12db6dd85699d9f4581614a8e17c14195"
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
