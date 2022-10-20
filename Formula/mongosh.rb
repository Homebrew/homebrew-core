require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.6.0.tgz"
  sha256 "01a9236c52e84d6ee89db901cdf90e9998904228bbdb2b96926b86c1ddd735d0"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "59d2e862ba4feefd0b1e9b5e2594641d0c5e3c3f2d7b402fab948d9fe4151c25"
    sha256                               arm64_big_sur:  "974ee086f8d42f76bcb97c173edb273b0eea85738c258c61c37f7341afd08836"
    sha256                               monterey:       "10abed852a285196c66fb604d35bf8d3dbc5c684e83c9b019799ab43509b9aa5"
    sha256                               big_sur:        "b7863d04124642d041545addfbea63aace4051f72f9b035c454f4cef73729f71"
    sha256                               catalina:       "9869df71d9a33af808df00dd17240de744958f88b8c7bea5288c6dcd870e651c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17396771b27a710bcc8b2fa2fbb8237c29bb1b5525f6eb6af3d03602b66eeeb"
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
