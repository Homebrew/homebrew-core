require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.7.tgz"
  sha256 "0715886b8ad7d4df364e88a0406c2c724eb4e8330ce7a21b95d3e15971c39094"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "37868e201ee0f99185af085956dd96ace9c67ef2a77251312cc8b4529245b7b8"
    sha256                               arm64_big_sur:  "8f25b494c93fc45dfcfd2e0d366d3f74d2a6209eeb15870bb5278e908bf1668b"
    sha256                               monterey:       "ab9347d2a7eb6132f8d9171e65d3e0e2cf14cf6ad7939d0bbc66f6f5b166c0d6"
    sha256                               big_sur:        "9319b9358f0e8b32e67f82412e33c62517f4daf5e734570b340b45833a08c0af"
    sha256                               catalina:       "f30ea6434bad8e32461131d6e84801bf1a2f11ea1b3d81c9b5625b74e5efbebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c364abfd156d8e9796058abf1beadcad97356d6bd6d64aaba3b343e38ba1e903"
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
