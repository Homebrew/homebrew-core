require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.0.4.tgz"
  sha256 "470de6b63f675af27d2e9870d804fa6a4c761c2c428f15989189534e74aa367d"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "f03fc5045c826fa9d60b54ed9ba10f4a6a20b4fb00dcf002655f0a0abb56cd4f"
    sha256                               big_sur:       "11946a9ce542a456dab88739f3ee7e27a44fc8971cc22f672ebda641946bfe2e"
    sha256                               catalina:      "0bc409f274063b4904eb190c288d0828de6cfa3f236797660837d862d358de59"
    sha256                               mojave:        "6ccf76036b723d26a132ee6791e583034d286810dc1c701b6d5cf7c084ccfa7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9cbafab99ee9cb9a7ecc84c365d1d9e0cf12436d7e0628240314e6c03ff85c"
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
