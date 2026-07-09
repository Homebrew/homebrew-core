class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.9.2.tgz"
  sha256 "a87a9e983f8d244de33b547d0b79d10acd1d1f59345a1b5bebbda7784950bce0"
  license "Apache-2.0"
  compatibility_version 1

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a7062caa7e13726d183ac320213bc52c04630dcba0a4136da102aca3f59918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a7062caa7e13726d183ac320213bc52c04630dcba0a4136da102aca3f59918"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a7062caa7e13726d183ac320213bc52c04630dcba0a4136da102aca3f59918"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b3e45f1e6d97d6ff19c9459f0dbca1608d13bf300c54117b90ad5909a906ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a082addae23ef77d9a280661989fe8958e267c64ed1235e67bd8188153a2374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a082addae23ef77d9a280661989fe8958e267c64ed1235e67bd8188153a2374"
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
