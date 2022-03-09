require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.2.3.tgz"
  sha256 "8439783b772a00a67649963d6ba610a602ac84eec8232ab42f6de7b07ef17948"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "9c10f7d8078273c239a8d5070cb91d1d0f44216a478f92d2790f508adb80b357"
    sha256                               arm64_big_sur:  "500cf712d5ee083700435133cad8a0300e60cbc8be66e32bd6dfd8f9a130eaf3"
    sha256                               monterey:       "9dea0ffb3003dc81be0a038b22d6504e9c00c60f8a3ab3310a0cbb25bad9746a"
    sha256                               big_sur:        "a546967c771e68d20266f3fec14134ccf31b05ecdf0636f42f6be74e11b9a808"
    sha256                               catalina:       "663f9040e01f0005724e521f8358d5731a9c0b21e9780131a78a42a371963a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d51cac602dd913da341c45836adddf4416e89f34d187165da275db2a055316bd"
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
