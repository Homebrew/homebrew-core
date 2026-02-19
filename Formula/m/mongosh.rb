class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.7.0.tgz"
  sha256 "70d0cf987892d2f06f5c3091c484df6bb8ea31d28ae9e2eee6525d4b3d9b644c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6cbad1f6298aeee7c2d3e21752aee729f8c0c6a59e7e53e2dd6cf705d8e9ef6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6cbad1f6298aeee7c2d3e21752aee729f8c0c6a59e7e53e2dd6cf705d8e9ef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6cbad1f6298aeee7c2d3e21752aee729f8c0c6a59e7e53e2dd6cf705d8e9ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "538b979ccdedb3a15eabca441d21664083d0425317719b733a434dd514f76b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431b12e2c1f05ee7c7e35bf890a7e56c607cc5881323f0579972e1702987fc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431b12e2c1f05ee7c7e35bf890a7e56c607cc5881323f0579972e1702987fc58"
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
