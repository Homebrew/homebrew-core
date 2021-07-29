require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.0.3.tgz"
  sha256 "1aa67f3636572d275543a2c09bdc5c74eef1c8a7fd88c52307551e20061a2b7d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "914ad1716df976cca9ebaf5216b02502cdeb16e52e321123ff04bc47aa1d6f56"
    sha256                               big_sur:       "10770c9a72b7374c3beb02d2d054d91677c8a03f9d5dce8e2ecf5cb897b024db"
    sha256                               catalina:      "cd955b0f90198c6622689531b3831b2418d813f5da41a6c2f7ccd63e10449813"
    sha256                               mojave:        "e868c50a7476c5faeffc1d8f14f1be416a3afad270acaf0c3332c07439cf4867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c708970f8290a81bab303f1c1657a109ede69f955d8ebfaae84960493e482fd0"
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
