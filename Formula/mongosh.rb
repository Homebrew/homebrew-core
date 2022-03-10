require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.2.3.tgz"
  sha256 "8439783b772a00a67649963d6ba610a602ac84eec8232ab42f6de7b07ef17948"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "9ffbe68bf0a0a0a2aecacc24da50cb2511126e5cfc191feefd99c353a3a8cd29"
    sha256                               arm64_big_sur:  "15585ba577946bef61c21396bd63f2177ac485cda4cc0913c894049a16e70c3d"
    sha256                               monterey:       "152e85e752df5351cbdd00c9c4e1d1ca29f33b4676e728267d55cd3b02ce4e05"
    sha256                               big_sur:        "edc5442a0f5def2bb3b45b62547126872f0baf4608e98aa814647b756ebfd3c6"
    sha256                               catalina:       "f5a8703251003c9a7315c95029f884589677105eee45fd176b8728e1bef24cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94027beca7b0e7c15b21378e1d070128b8d380e71c1cf2637d5d270eb2dab726"
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
