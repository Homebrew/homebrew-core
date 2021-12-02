require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.6.tgz"
  sha256 "11edac1680c6ce144257a456e9242f44a1e2b38f0d2aa55e66ce826e6fa52eef"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "d31173d5099ab07fc717dbd82b012e7e1f94777113173799972f59294fc0e19e"
    sha256                               arm64_big_sur:  "05e145293282cde3e2fcc3d30e09898970ab2f87504008de97197b82fff28050"
    sha256                               monterey:       "cef5ca9d6c86783ba788d343154bcaef1014bfafdea6c7bfd18f93446c5a8ceb"
    sha256                               big_sur:        "89f17f339e74efd81290053dab6b2f216f478f4856c2a2670bae9dd9aef4626f"
    sha256                               catalina:       "e27ee2e8bc92f6dee5fa4385b234f0059235be751e3b97cc6ce34c76ef34f177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "416467581a04be56ff6b1caeffcb9de8e4ba50313a42e8970ea06aaa1ae58ca6"
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
