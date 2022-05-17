require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.4.2.tgz"
  sha256 "6a365afc8a67d865416e0627eeb7e9512cd0b1686fc80072750b7de075c863b6"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "16adcd1f16b84d090f1a94818dc4f6680f0c67de8d6d5a1e31233897a1398a7c"
    sha256                               arm64_big_sur:  "c8457eac7f4b1f132520bfbc1ab6831ad9d22ab0aad8e8541512d4febaa549c1"
    sha256                               monterey:       "00382b102c6b89a660d8a0c2dbb14721ddec0f6d7cc2468371da203a2fa2c053"
    sha256                               big_sur:        "b469edf2765626f4d80b8cd176c243915c02797c8070eb5f2deccc2215b2eba8"
    sha256                               catalina:       "dc6fe7a9c6ba1a7c8c31853407094a62d8aeb1037d0edc4b723ea92feeee7083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96affb72093ccfdedfecd518ea5ffa5b34734739e3fadeef360cc0a7f02f7412"
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
