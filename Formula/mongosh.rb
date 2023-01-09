require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.6.2.tgz"
  sha256 "393183cbd977cdf52b8d59b868f7438d29f2db2cd0b4cd9646ef7d2cf98dab89"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "50a8d799527a5edb9f5637e2eb5213ff8090ed1be2c4703803e743a7da59c091"
    sha256                               arm64_monterey: "8df4816c70e0bc37e1891c6cc11a60dabe1eed860bce50dd519c2cef81ff8ee4"
    sha256                               arm64_big_sur:  "8a08a5d6ef761f57c802a05d85ebe0fc60d4ec50b41d8762aa0a8327e52db098"
    sha256                               ventura:        "9489ba35cd47f161f887e27590496c46a77d14781ef740c136963ad87434899d"
    sha256                               monterey:       "30abdb96455270fa2399d275ca4f43269befae72da68fc755c367f2be2e376bf"
    sha256                               big_sur:        "845dcd761de95c75465325fc54aeabec258dffe1faee3b053af9c9f98a2d5f9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9591936e408af534528dca42130726ca8c649046ca4b145047376173e404c8ad"
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
