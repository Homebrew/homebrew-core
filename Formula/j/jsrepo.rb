class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.8.3.tgz"
  sha256 "32f4e6afc5bf816359cf700cd1369da2fb23ed74ea442ac4d580a1db11f3c43b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "45d8cd56e80d59a8c26a342d503b4dd5dd2c11e9c273be1ed91d597dd022c3fb"
    sha256 cellar: :any,                 arm64_tahoe:       "45d8cd56e80d59a8c26a342d503b4dd5dd2c11e9c273be1ed91d597dd022c3fb"
    sha256 cellar: :any,                 arm64_sequoia:     "45d8cd56e80d59a8c26a342d503b4dd5dd2c11e9c273be1ed91d597dd022c3fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00e3d94d9c5a438281333a8a2a00f26d89f242f8ceddc0a804b7869d4b7ef70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "815629090aa628697c8d04846d7f1d0d9d9296d5124bf00f538838c1c6e14b9c"
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
