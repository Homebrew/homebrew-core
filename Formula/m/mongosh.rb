class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.10.tgz"
  sha256 "ae1a9be2ab8e8c5ab37e436129799577943e160bac58bc893510484e4ab330b8"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51b764312585b0e918c40b648ede465b04ad0b9e3a4526e7cda7184e56413fbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b764312585b0e918c40b648ede465b04ad0b9e3a4526e7cda7184e56413fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b764312585b0e918c40b648ede465b04ad0b9e3a4526e7cda7184e56413fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "30bcc38c17624b628fd1a256fd638c42d093a113a0eb313e998b4c64c75f5e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "756f84e2b00017c0ab40ff7687c92b495e95b513ad21dee8dfef21b3f097fcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "756f84e2b00017c0ab40ff7687c92b495e95b513ad21dee8dfef21b3f097fcf9"
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
