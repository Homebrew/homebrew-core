class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.8.3.tgz"
  sha256 "ef22725d4efa1768e8316b6bc5aef9f8298136139dc1821719e239fa341cbfd6"
  license "Apache-2.0"
  compatibility_version 1

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d14d7ee324a8f078aa8909cab4cef5cb99d22b3d6e15e45e9b61f70baeb4975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d14d7ee324a8f078aa8909cab4cef5cb99d22b3d6e15e45e9b61f70baeb4975"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d14d7ee324a8f078aa8909cab4cef5cb99d22b3d6e15e45e9b61f70baeb4975"
    sha256 cellar: :any_skip_relocation, sonoma:        "672ec3ce969fe94f3679587e0b2ab9cd7d5aed80992a05be1b160ebde1d74689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c00f0f02b049d44581e9ae5fc43fb89531920dbe75f9cd262e54f40da8bcd9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c00f0f02b049d44581e9ae5fc43fb89531920dbe75f9cd262e54f40da8bcd9c"
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
