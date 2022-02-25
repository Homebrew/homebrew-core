require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.2.2.tgz"
  sha256 "a42f7da7a5f0f93cff0753c62df8b1d34bd2638bd104149e3a7bc099a119ef32"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "e306fb38a5a9253a3c839a25ebf751b24323bd750b20218907023ff5e1f6748f"
    sha256                               arm64_big_sur:  "1bcb0ff815ddd5c59dfe094a3f108eca3ff953370f9e72c9afa350e4d4523a1a"
    sha256                               monterey:       "8ea1c7eebe881b9d479e141398218b5a3e34cd599015ab11c05cf8a39a67c1c6"
    sha256                               big_sur:        "7ef709bd152a87adce08e08ed6103bf6071020cbeacd94cd32190032461c7488"
    sha256                               catalina:       "d7047a0e0b35b8a51d93dee2afbf137cfa051d694b340d778ded73f72805a8c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1d0786c29958b9881e5f017367cc5b68b2dee4412b751a8d8adb79efe2fdda"
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
