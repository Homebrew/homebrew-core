require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.3.1.tgz"
  sha256 "e40df53ffd920a1abe90df46b11ed63de6874249fe4fc4301a96a309dc0bacd7"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "e01f4520a7f2327b14f1fdc79b31af4b6129aaee8769371bde111111015ccda7"
    sha256                               arm64_big_sur:  "a45f60bf0e8c3ca5a478c61c923aa9e538897203523dd1a1b22fcd0328973bc6"
    sha256                               monterey:       "d9a2e7da32ef816d0fbbe8fada95495ee6214ed635ad93776bf654a978ab58b3"
    sha256                               big_sur:        "667f64f548db9d4efaf17b7a7387a41eff9e5ca0eefe941fe448fa356a551357"
    sha256                               catalina:       "740c9a1b2ba4bfb96afe49bcccbf8a6cde49e6b6934bdc3dc20cf82567ae7d73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80caacd9bd2e4c3997314c9d7762cc3eb8f7fe5daf8482e79cfed116dbae0cce"
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
