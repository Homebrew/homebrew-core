require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.10.5.tgz"
  sha256 "3fa241c40dc93cb68d56af9ee0c2ed6d6532d61cdf80a3e72f56974a6eea17d7"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "44aebe4a05dc8d023672d0544c442ec630e61cf3a791e5d5ba7552f33a433099"
    sha256                               arm64_monterey: "18626161ca4ca78ddebb906b5bd1a0038ac40adaf41497f8b7bd8cf553c1e10a"
    sha256                               arm64_big_sur:  "5aa8625d2e97fa8075beaecab7ad0d82cb8fea0548d5df24a920fce14a0f5c60"
    sha256                               ventura:        "b6ad6c99de6d54dccebe2d58c75da8acae5a4d4d7c477d6e71ed2e13abab4d86"
    sha256                               monterey:       "a86cb35035ecd27d1797ea465b6eeacc4e853f61403c3f2f89e1040cf512662c"
    sha256                               big_sur:        "6c18f6933d5712c4f25895b3487b2f383a5d16e1785ca4a9e2c0355ddfc3748b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee303353559e82befade4d8f6cd05b0c492ac6b055de96e1446bf6d4d3f0135"
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
