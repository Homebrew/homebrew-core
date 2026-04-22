class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.8.2.tgz"
  sha256 "0755e3ecbd9c0c701ceda2ac7cc09abd115488d51d81b35ee1b3059624847cb4"
  license "Apache-2.0"
  compatibility_version 1

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d67cc5c70961c77a5c3ecf6aeac41082d7623310f1458f00ce5e55b625e2a0a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d67cc5c70961c77a5c3ecf6aeac41082d7623310f1458f00ce5e55b625e2a0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d67cc5c70961c77a5c3ecf6aeac41082d7623310f1458f00ce5e55b625e2a0a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "483a78843385fe722bf8c07ac6e936f90ce4f3ed0b59a1295a8cb8b950047b57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d38657b01483b66c75e0d436ec172972b6d2c2e33eb2e4876bae098048b549d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d38657b01483b66c75e0d436ec172972b6d2c2e33eb2e4876bae098048b549d"
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
