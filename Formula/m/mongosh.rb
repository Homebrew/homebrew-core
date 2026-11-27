class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://www.mongodb.com/try/download/shell"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.14.3.tgz"
  sha256 "8e21711ae4d58e83764a41d0ca59c3374355804343b06a6abd648577aa426ecd"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "ebe82dde4117c7769a130905f3c09f2de5929088e5461b088410de14dd8aca00"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "070ac2f0cb2f938c45875b3092f653be20d734bc47ca4af26de30f8aab9b6006"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "070ac2f0cb2f938c45875b3092f653be20d734bc47ca4af26de30f8aab9b6006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "070ac2f0cb2f938c45875b3092f653be20d734bc47ca4af26de30f8aab9b6006"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "41beb13ba831682c7e113cf49fd8a6013d7fab9b708c39cda63d747607e3bb6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "41beb13ba831682c7e113cf49fd8a6013d7fab9b708c39cda63d747607e3bb6f"
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
