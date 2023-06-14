require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.10.0.tgz"
  sha256 "159ce077fa1aec1dc422fb777e2d770153387381f40d310eadc6015673882114"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "032ef051c5abb073e1c7a3d23661083602c93b970f4593955f73807692020409"
    sha256                               arm64_monterey: "f66cd29a405bca082b88b49f8560645c50d1348707b386a6afbc28e4aeb61b3c"
    sha256                               arm64_big_sur:  "5b088ba27c3b7ca85b3d96e6cbf5bd2c1e07b0944c30abad85dfd1205ab4f21b"
    sha256                               ventura:        "05ffcb9c041d6412b95b6dd84ca8ec79db63ec978a6ddde850bac2f27a946d25"
    sha256                               monterey:       "304cbfda72c8831a13cf84b6f12e9e4b59109b947c5730b1bb092112f27bb1ad"
    sha256                               big_sur:        "a749d435e3a31f06662fc22f75ff9210beb3ee6414606aef69d96d7372ad3e04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f68cd0bc18301e65ac3321deb36218f553f494fb01c153010fe96c6fd1122550"
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
