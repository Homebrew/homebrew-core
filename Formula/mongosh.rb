require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.15.5.tgz"
  sha256 "dbfbe9c5c571d19740f2118f0f023b38836be8ea2e49a1c9be402f108d2900e0"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "983faa145f477faa6d1ae86297b94891337cf078744665f55872d1f1e2c775ce"
    sha256 big_sur:       "ef4cbe48c28544545336ffbbbf496ac5356f6ac0664946e07aea9e8919ee419a"
    sha256 catalina:      "4a58fbaa7909fb4b357b55559ebfc17aca89c2c5149c81edb0d41d731fee5f2d"
    sha256 mojave:        "977a9348200657932d1bd355af6f342fc25d08df37b3c5673eb2e922796575fd"
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
