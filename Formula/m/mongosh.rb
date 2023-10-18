require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.0.2.tgz"
  sha256 "c2e606dd4f90f85ef9258524740d5b4294af530a6086f655fa23444f1d562879"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "e5e918821582940a59563dd02b5a2da37629befadaaab9b44bcca58979f54e35"
    sha256                               arm64_ventura:  "cf7b333d47fefc8174f1408f158aa78c68a5629df736f1241ec85df7d6187c47"
    sha256                               arm64_monterey: "aacbef0e3e9853edb54805b193482d0761db76c2e0537f15ca1a027350ac63e6"
    sha256                               sonoma:         "e80857e7f6f4681ea57fbe1d2076b954d88bad16659907171534c61188ea4c81"
    sha256                               ventura:        "f3a8b08e0490e6b40bb35c33d2f6c5634dd5ae8f7b0a72e95ea58c5e91c939f9"
    sha256                               monterey:       "9e1fa810bbd0fbaab6fe3d0c39f09bb7e69f201ff50ee88c0656612ffb62dcbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1f3c08082eb82e967b50a03342f0775a000df4ef8839b65ec73a80f3cff81f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
