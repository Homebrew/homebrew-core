class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.13.0.tgz"
  sha256 "a83ce9dbeee09f4dd05fece99e9cef99e674fb7663fdf8b94038510dbba52cfe"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81d9e55182927822b7d209e42288a05e7f20691e7e70ce774e5509726dbfff02"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81d9e55182927822b7d209e42288a05e7f20691e7e70ce774e5509726dbfff02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81d9e55182927822b7d209e42288a05e7f20691e7e70ce774e5509726dbfff02"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a2d5094d862a64af2bd0f17bc74c0a307f86074ec1c4c3d28abc8c1638af1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6a2d5094d862a64af2bd0f17bc74c0a307f86074ec1c4c3d28abc8c1638af1bd"
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
