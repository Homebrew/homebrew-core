require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.9.1.tgz"
  sha256 "f7cc6072eb17b72fc0cdb59a4e2afde60a907dc6ee28a0712915ba7dfe5390f4"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "3121dc66423866e2660a95299bbd7776be715f4666114b39aad2e7e00e74421c"
    sha256                               arm64_monterey: "e8099153f153e82e0b9995fd6ef1b88c18286acd413d36b59c85864eb5258db4"
    sha256                               arm64_big_sur:  "f6fe66c3f7692b574df804992ccda2c27350adc7874046af106f971b462caefa"
    sha256                               ventura:        "b351bfd2803556187fb52a522e984ecbd81e1f74544d410c4ad52c63d5b78d18"
    sha256                               monterey:       "139e7570d8d5dd862ec03a921cd3bf9015a518d04c522aed348bcee193461b94"
    sha256                               big_sur:        "68bd795554652fbd446c555326a82f70afb083bbf55aa77c57ee28aefdc37b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e7e05a5f102e1f773c4f37d39ee2f845795221bb24d8541cce256123c814a3c"
  end

  depends_on "node@16"

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
