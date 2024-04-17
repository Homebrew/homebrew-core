require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.2.4.tgz"
  sha256 "a94f0e947352e10dfdaa1e3188ed8aa251b901d0c3aa1923fd3284036b26b2e0"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "8c284258fbd95f957a3b9bce11835a29bddf7b271330b1c2d7e893739dbe95c3"
    sha256                               arm64_ventura:  "28dabb81fadfa0adad57dbce2fe5a42c7d495ee4e1557ad767109fe0efc59e9e"
    sha256                               arm64_monterey: "fa6da0b14ec9902a86cc8237eb3849d8a537d6a38afacc03634e76255455d9f9"
    sha256                               sonoma:         "d3aa9bba0e18fceb4534d41e065ee5069ab1a6d359570ad2b39973415f63301b"
    sha256                               ventura:        "f893c2e8ff6cd0c7dea1c4c3928f1acd0031a4cc77fa1a7150f0c24b353c47e1"
    sha256                               monterey:       "3abe54213b39af006d6487c4cce4d361198558db27573f1632fed8500b55401d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc458f42e3974b2a01f0332630cef273fdc2790d164b47a196a50f5b552e72b"
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
