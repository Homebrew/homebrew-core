class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxlint/-/oxlint-1.39.0.tgz"
  sha256 "a022506061be306b81970274edbee124a92ed3fc4d4155ed6cba5fb39c467aca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7ca55ce50f4ead85b1ff01c438367263d015018f8191def6dd803fe4d8b715fa"
    sha256 cellar: :any,                 arm64_sequoia: "214ffa3ae43edbb4d25f67af7e48b47592e323aa641ca6681ab1fcf8d3ab7a1b"
    sha256 cellar: :any,                 arm64_sonoma:  "214ffa3ae43edbb4d25f67af7e48b47592e323aa641ca6681ab1fcf8d3ab7a1b"
    sha256 cellar: :any,                 sonoma:        "b938e3e1edd1405f5baa2e34e6bfa3dbe2fc7b6c70f2eb91e3bec7e511f88547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02d4ddb080c5e234a5a356a70a9a80719d781a3aa0de77e6881041f1699bdae9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b05a7338c2cc06ec8d913d8cd43e585aa3d8d93d67893b492008e77eb6610f9f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end
