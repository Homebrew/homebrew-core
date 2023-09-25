require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.0.1.tgz"
  sha256 "36b60bca81660088c361c3422656acb18f5c037a5fbf3489992bef33e4be3d63"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "b5a84fe8b3f279d244f2afd5c9d60456ece09c0ed7ff278c57374481b96c3967"
    sha256                               arm64_ventura:  "48bcfea84d679548db10cd2721754c8e44253de9a10b863176d40d8320829dd6"
    sha256                               arm64_monterey: "fb5da67af28fc05d2778bc3b0a504bb28800e83c84b3f4448cc3d6e8843f774d"
    sha256                               arm64_big_sur:  "c9f100c478778fafb3fa6f3d099ab6475b670770be73fc6d4267e26d4de5fceb"
    sha256                               sonoma:         "3c85e6c282609a26de407841f105390a9fc21117d357218e1e9907f3c9e81c64"
    sha256                               ventura:        "8d83db48a99274d8b11516bef376110a59cf7c27346d08cc5cda0bd4e3a76e3e"
    sha256                               monterey:       "3f134553b42bf5f0e518e2f73eb2814a361a4fbc79d62d28bab460c9c8b9fd76"
    sha256                               big_sur:        "f03488ab4dc6483dabdab04b6454ce81fda98e97927cc1621dfcb627cfb48381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b630dd6a2e8b94facc619b96a85050c5493c39f8f622071d5b3de7479d44e59"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
