require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.0.1.tgz"
  sha256 "24e9987af7954bca35974b4aa1b8b295eedb489b5812600ab7107941a1d79765"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "d1a73f121e5de40e7e2fa775f827fc6b280285dc9f0a80e9600be0db87c53602"
    sha256                               big_sur:       "d13267653aa072053338ef0fd22b92352a34877a8f389e2fe5ae69e0cf332695"
    sha256                               catalina:      "705a094cf52991ea54b4851ca11794bffe0c64e4e34c95e2cf0e958eb632a79a"
    sha256                               mojave:        "5de91eed5a449d2099b649eeadfa274bd405c9076d079a3bb52c8c3a70e8adca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a32021cd219ffb05a6d792e01f749f2c310b338e0d43f880283cf1045044b6fc"
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
