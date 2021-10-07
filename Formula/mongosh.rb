require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.0.tgz"
  sha256 "1ebe806f4b9aa75687caf756c21da1207da829a6a0e28f95f108f467d571b672"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "00c7deb52da56c1124ac5bcb5b64f528b4b7e935cf2f886b1b9f55f85bbe2a38"
    sha256                               big_sur:       "fde56474441d5c3eaaac7845a8d259a81e41d906d9c4752e838ecefb97268fc6"
    sha256                               catalina:      "c2e49e81ffd7795d6634ef544dfcf384d1a404f84fdb76cc74cbc4dddc219ee9"
    sha256                               mojave:        "56d213c8cd8e71ecb486619d298dbeefb5e34c92921a962da4aa23e6a4aeccfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29614c6dfd5ba9afe6b4eb3b96fd3923fe9a5f3a9dfa1e6e2dba10de01c3279e"
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
