require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.2.tgz"
  sha256 "da820f141f11012a608e58717f0491753656db832a090bbc2e2a0b0e2f5908ca"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "91e2ff61b9bde77c69482095b6f1a8c95eec0e3b20722debb33603e9ed6dc0c1"
    sha256                               arm64_big_sur:  "e2869abb7725902c30e9cb7ccfad32cbfb729abe8670b945b7966e4bacf83402"
    sha256                               monterey:       "89b6268a222cfb75daf61e89e20dd2823918de622e081f0911e60b978edbee00"
    sha256                               big_sur:        "2d5132bdf22c993f0138416c7e0cbefb36fd7a7529a88a6dc67853a63c4a1a05"
    sha256                               catalina:       "8d2397a2da3f7b76420d336bc1dc4ed871a9852a0b99af04a03b8d884d7580ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5961be3fa20026ba5ebd3c2b523b7569f4fd651dcd3cfb708d2a1897b8e93a59"
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
