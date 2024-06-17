require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.2.9.tgz"
  sha256 "404760feb7a84a241db5ab60a0e631b2aee5b1d819ec5a558b324b2d77471eee"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "e1bac4c7faa5691a84cf3abfdddedacd3953e7a98b296964e22a4f9273bd88aa"
    sha256                               arm64_ventura:  "35b3ec440e0b729b995e5b07e596359a192218055d3bdb288e325cb984d97ac8"
    sha256                               arm64_monterey: "e7cab575a729b4f0174fd8db0cb3b74f9dd2d345bdef8bf92e07823d11a83ae2"
    sha256                               sonoma:         "6f24707e4ccc432ded48205e2a40cf4d91cf09f7b47311c88147f860b9f13f25"
    sha256                               ventura:        "1716aa274ae962bd2d647bd1c47bd71f7feea4f21dfb86bb794381458d8130e7"
    sha256                               monterey:       "6bea7e166d083cf7087a463cc71f2bec81d6940d1c33e8d8bd44abfad0dd8a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fad05e290660d9e5ea9cae330d4f708ae4c1d7e8f93b3adbe5693d84b3bbada"
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
