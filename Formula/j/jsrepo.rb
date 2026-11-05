class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.8.3.tgz"
  sha256 "32f4e6afc5bf816359cf700cd1369da2fb23ed74ea442ac4d580a1db11f3c43b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9365e395e9e2c0ae159b100d888d02014092a02dbe59ac4e402e01e3ccefce1e"
    sha256 cellar: :any,                 arm64_tahoe:       "9365e395e9e2c0ae159b100d888d02014092a02dbe59ac4e402e01e3ccefce1e"
    sha256 cellar: :any,                 arm64_sequoia:     "9365e395e9e2c0ae159b100d888d02014092a02dbe59ac4e402e01e3ccefce1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91570efcd6b5cc1be5b787b9efd8f4ae4b32bddbb909e285f8c5ac5a2ff61436"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2325ca77996eafcd20375ef45bdb1269a5ff76536ad0189ee8df5c2e740cbb27"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
