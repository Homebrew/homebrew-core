class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.3.0.tgz"
  sha256 "a341b978f0232fe75d66ec188e50e8f7e56cccdd785f009a06b00d706c3e9021"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "30ae1687f4caed315ba8ee84f1ebf4ec106d94e94d6004ac7793baab42c08827"
    sha256                               arm64_ventura:  "130a3c74d86f4df7c41a3aea0eb40c6d01ac11e77753120340ecce1235083b07"
    sha256                               arm64_monterey: "df3c9eed709efbc49a1fd2488ef7ed109a6f87fdc3539528d2b559620fa6762b"
    sha256                               sonoma:         "7fc6be19d25b869f8f8d3d737d38a1d1ca8d85e06e41283b6cbf7392d4739c8e"
    sha256                               ventura:        "a660b7b1288b29bee155e2e8d42f3bee9a3dd86ab54ce673f69e7884526e3da6"
    sha256                               monterey:       "9d0987f49d4ff5c8a54e744565c34e975167b9dc0c544228754c0106fd70167e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17c01d0987ac1390d4ba1eb9003ed869d70f9db4d93ee8fd2347089ce329ca98"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
