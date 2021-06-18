require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.15.1.tgz"
  sha256 "48fa321498aa07074974c14f91c30f45330b6d11a95a3219ffb9e190b2d9df44"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "c70d7dd5bfd4085ea1d114c47bf69ae0765bde6d5e6b613400c146014ebc986c"
    sha256 big_sur:       "11b8c04acdda9a9793453c6775cc7bf459121fde8123079d71aa753417123680"
    sha256 catalina:      "ca84c2c7ead2fed0a22f3310007e145bd988f37d11f1a0f2dd5dd9c9b7bb52a0"
    sha256 mojave:        "ca04c8b8b98109f79c60650398744720b36c622fb6057e13c9dea9493feef533"
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
