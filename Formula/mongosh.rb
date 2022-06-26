require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.5.0.tgz"
  sha256 "bcabff0b1dc6a400ebe2114783b44fd91d000e31d48c81d760e2b8d0f157d2a2"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "7145461e0eda3946d97fd32d74ebf1959279cea96d7904fd92c5f7481fbf6f89"
    sha256                               arm64_big_sur:  "7e9e5b53e21b9b8d647a987902531144555d09d7213af4b280c50232c9cdd050"
    sha256                               monterey:       "9548999dc2e8372dff26b2d14d154edc5df1307ce88bd2a93a3788f214f20e24"
    sha256                               big_sur:        "4ca1e8a30900988e81726d208560dac5766f2bb7fb95909e56d3478f7a53e6fb"
    sha256                               catalina:       "a1c371dc8f40a9d300f1ada4656c22a9dee4327e6f849e0cfbe9e13c90ec7b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687161b527c2fb1d03860fa8d4b1fed17bf27083157f559664f6ce5d998178c9"
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
