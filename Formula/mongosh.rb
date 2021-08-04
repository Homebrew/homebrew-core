require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.0.4.tgz"
  sha256 "470de6b63f675af27d2e9870d804fa6a4c761c2c428f15989189534e74aa367d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "4f47ed570e68a1f7c78e469dbdfcc1d9c4a6f85466d22de16bef4fb75d9b0198"
    sha256                               big_sur:       "66c1100670f58bc4bb66584cf5d7690c4e03227c09dfb1d160761234957baa91"
    sha256                               catalina:      "b0edf42ee4f22bb6c0bb80db54221fed492115db8fd67c21264a487af1f7e556"
    sha256                               mojave:        "e34c51bd6bd8df88d288b1701f36782988088b8688309c0c1e02f3e6a391f4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b542b8a07c73577706ece54cecc777b95795e82444ce46642b767a60a6906504"
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
