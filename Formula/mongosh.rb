require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.2.tgz"
  sha256 "da820f141f11012a608e58717f0491753656db832a090bbc2e2a0b0e2f5908ca"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "6b4e08c8fcec4cca588002bac497eaa595790894b0ce70c3e4706ab1a2ab3ddc"
    sha256                               arm64_big_sur:  "6aa3681f5f8f00e6f729cf13b1f4c0441c581dd4afd04b2f83c13df8dc804fc0"
    sha256                               monterey:       "88656f02ce2f58a421ef1d74dcccfd1f2813048fe13eeb51bcb26134e56f8d0b"
    sha256                               big_sur:        "3b052e833a4fb465ea52ff8cb13dd0b28e5d5b4c361c31b29aff6b8fbf7d80db"
    sha256                               catalina:       "99a8a9c20ed9576dc3bf55704ac488482227d5d43dfd4d585ed2cb15afad0996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a47aab9005c35cee091bd0d0e84d0fb688b469bb9a247a0944181e43db2bb37"
  end

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
