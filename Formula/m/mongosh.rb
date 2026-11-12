class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.14.2.tgz"
  sha256 "1efaa21ac89c487353da83e3b5a59c2986adaf7da0d984d4a8d9859c70d9daae"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d9676ad5671422ef3f271ac5c2e2c3015e41b4931569c4121ba7122aa260ea5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7d9676ad5671422ef3f271ac5c2e2c3015e41b4931569c4121ba7122aa260ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d9676ad5671422ef3f271ac5c2e2c3015e41b4931569c4121ba7122aa260ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a7f0c0fe173dee510b7bbdab31af10067e1055a89cf35043d466d733f3f352c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8a7f0c0fe173dee510b7bbdab31af10067e1055a89cf35043d466d733f3f352c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
