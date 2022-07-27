require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.5.2.tgz"
  sha256 "980158d90fe23df978e80b82b738c6deaf2fef4adc64b050332a0da4db7505ae"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "065a34d8a8ac8ef424795d44be74b1ea8f5248242af114301534a9ae69ca9e2c"
    sha256                               arm64_big_sur:  "c219c1d134399e978bcadcca1316442fd6b043032e63809d6cd19f5ec0522fc7"
    sha256                               monterey:       "062d16073860c04e285268bd441ebc2d7d19c4e06c2164f3ee8f9cb27a7b1bfc"
    sha256                               big_sur:        "7d57fd2a425b19bc382b769d8cdb1358d2e4b12eed6b26b33581c054eff4217d"
    sha256                               catalina:       "62d4b2eab04f6cc1d78750813f74b2be7a27554c24a92a7310f7ddf7f46cba14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25e48346fe0bce0f115c0dd3bbf852d7280d7737634f9eadb67b490535ab3e1"
  end

  depends_on "node@16"

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
