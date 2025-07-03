class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.5.tgz"
  sha256 "48f38d64eab47bab750b238be8233d43e2e703c2930a81eee3deacd0a3feb034"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "c320ba5bb477bcaca201ba183fdab797cc2c97f54f84256615b5efc350167567"
    sha256                               arm64_sonoma:  "e20b4f5d4d7e3242bd4c2ae36194d05d549785f833d73f69d8ab54bc17fc2d61"
    sha256                               arm64_ventura: "0138679cbe59247f35a72949127893ec7d6f0891de0a69f2d2a4473b8732e8c5"
    sha256                               sonoma:        "bcd35016ee684bd90cd359db1311413f133aa1a510a6c90c40ba875ebecd4fc5"
    sha256                               ventura:       "3726c01776a118586380de595d75e50ad456b0504db944ad18901e8d24b9cc05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "046f467214c0521d5d21ea65444ccdb32c20f5d341fff92bd83a5718d5b623a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb91a9626f26ec62c5b215481df313ee2c620caee32d157e60235aeabcd561c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
