require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.10.1.tgz"
  sha256 "1676f3180d0f6d9270c1f8bc44a4e40182731d5718cf3ab1adcf27d26fadbc45"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "2752d76ab512cd64c353853f8c9002893c11dd2c07487bce86580ba9fc0b4b7a"
    sha256                               arm64_monterey: "1fb13d6065713b5088b091c9dc0ed5530901fa8e8df1544282a7a481497cd001"
    sha256                               arm64_big_sur:  "cbfaecdae242ec69ab71b3dcd5e034f8206eec89531134e00bcc7da46fdf42c8"
    sha256                               ventura:        "3a301f8342bc74c4be4745ffe932f37497858e06da002540c4be08b9f6679c42"
    sha256                               monterey:       "7255c4a78d0c80d82689ef47c837e17131d1ed11327d2415fefee485920a278f"
    sha256                               big_sur:        "6cb76ea8a325606aa2ca45a15b5924d8d319a18d448eb3434ac1857810c57dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f2f5f02b1a77a56ed3b63b5c449defb0a38509c2299336840fd5834805eb07f"
  end

  depends_on "node@16" # try `node` after https://jira.mongodb.org/browse/MONGOSH-1391

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
