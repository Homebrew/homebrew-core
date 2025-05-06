class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.0.tgz"
  sha256 "98657fd4509a49110f2e3be1e8f05a6af47d285e31f339dcfbd1fc84278df5cb"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "2ec5e335106903f3df6fae44a84ac1ce9c8aa1f56c9b7451e9df5c8225d61216"
    sha256                               arm64_sonoma:  "0b843da4ebc97f1547b1eca6ce4c3e37cbea7e7d63e1ebd5b52206fe690441c3"
    sha256                               arm64_ventura: "453f424718db86458d3b7f8e22a95d8b96d8738309a04f822d4a2ef66dbd521a"
    sha256                               sonoma:        "9ebd752fce4c15cb9ce0857c0920596f24b4aa61f4c4b139e98cdcb352171a3a"
    sha256                               ventura:       "1f457eda9511a1cab0ae90c9e168e6f35ee1a1f672df5c8594fb16133b6d575e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7955e0e4e7b7e14ba7c3f899311c4f29e6e6edba452d1c376d25063da358a880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f913901422020a94da2011bbc0537088c66216e43a539610003ae5689b8e6d7"
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
