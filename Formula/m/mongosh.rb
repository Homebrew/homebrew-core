class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.8.1.tgz"
  sha256 "abeb47fd4251abb569d2c9132b28f79e96f41c7983eb3505db9ee393fb3b10f5"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc5503176400ebf8bc1796fd4d8289816ec190da0e8d7b15c3eb421f48cd2689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc5503176400ebf8bc1796fd4d8289816ec190da0e8d7b15c3eb421f48cd2689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc5503176400ebf8bc1796fd4d8289816ec190da0e8d7b15c3eb421f48cd2689"
    sha256 cellar: :any_skip_relocation, sonoma:        "6951bd1d1ef8070dc1adb1d5530278b501ce26d6864b88630d11948992dc1c90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f14972c5ac4cd58d05c6d2388b94a9e059981d59c51e8756352ba0b96057db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f14972c5ac4cd58d05c6d2388b94a9e059981d59c51e8756352ba0b96057db"
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
