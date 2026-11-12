class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.14.2.tgz"
  sha256 "1efaa21ac89c487353da83e3b5a59c2986adaf7da0d984d4a8d9859c70d9daae"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "afc2846c02b3eacba117bfb485522a36c6d0e88a5562f81f78508089261a132d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afc2846c02b3eacba117bfb485522a36c6d0e88a5562f81f78508089261a132d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afc2846c02b3eacba117bfb485522a36c6d0e88a5562f81f78508089261a132d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9ed187e17bca312689b320beb580b7934526aefd5a7974eb99cf1e12916146a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b9ed187e17bca312689b320beb580b7934526aefd5a7974eb99cf1e12916146a"
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
