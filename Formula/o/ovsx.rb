class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.5.tgz"
  sha256 "6c20f2ed2580a6ee4700350da226befc8d28419417124fca5a84fbc200490101"
  license "EPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "021c68046daa02c5edaa74b35933717f7144199c82edcfcf85f9a7ac21c2dc72"
    sha256                               arm64_sonoma:  "b8d3d472537cb3f599d55ff06b070090f62bfbcb471022cf9232e5bea59d1bec"
    sha256                               arm64_ventura: "e1980a772c01f68d90ab1d1da1c844b410f82ea0afe3834169b959642b1112d8"
    sha256                               sonoma:        "4a2deeb3b338a9c896851241e581f91a110d134667af95ae99920becb5e006d8"
    sha256                               ventura:       "551128b6c61eadd36ab8a280d5424069dc85b91ff813f0a73826f83773f0f3b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f905ca29b8e8d9f7f51eb85c5dbb1a3fb07c8fbbe4c4c2b7d830917288975977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a675c25475f1cbb84c7bc340e6a3554513557ef248bd2d21fc392f3e943f50c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output(bin/"ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
