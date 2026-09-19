class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.12.0.tgz"
  sha256 "8547e3c755c2de6352380028b0cf70eda54ac625f6ca06512d407dafb20d0f4b"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e673266b83ffd9769f62126d782982e4015daef1e8d51972ab57f6d7bbc9520"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e673266b83ffd9769f62126d782982e4015daef1e8d51972ab57f6d7bbc9520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e673266b83ffd9769f62126d782982e4015daef1e8d51972ab57f6d7bbc9520"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f6c915eead76d12cfcc8a734a5c67145286768e8e37f6033061d0f3c7d9f5e0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f6c915eead76d12cfcc8a734a5c67145286768e8e37f6033061d0f3c7d9f5e0d"
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
