class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.8.tgz"
  sha256 "6f3479abf8dec8fa38b096168bba41783d937fd954cfc0e5675f1f2bddb603bf"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "18250abc4287a61b487172f705f42b0880ea5b3647bc27fb5b3fae23c31fc094"
    sha256                               arm64_sequoia: "601e71af05c365f1129e9a7274df01d7579319aa50f8e95d31e57186b43a8221"
    sha256                               arm64_sonoma:  "27e0df3a9a74950d061a8fe9f2fa2faea2f3d51f2b7dd0dab01d14149dfc654a"
    sha256                               arm64_ventura: "add8407a5cce26c1be761b5b2fce1e8b9fc3ca5daf8f7eafc3800d41bed38063"
    sha256                               sonoma:        "f8fcee626d042d8a3f1bb59154701323a43afc3ece0caa2dad839cc5f6182515"
    sha256                               ventura:       "f79e8236d5f43600af99d27057124f9fe0bac04702210437e3f73cfd6732b0da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d0c95106cd740ff049e4bf36efa6fed0d25cae9472da134ec7c4d85c7edaf7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5af747a5c3ebea4dfcd1d5bc97d6d99c74fe4e28531eb19248b4da72c8315878"
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
