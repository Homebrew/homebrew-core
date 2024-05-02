require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.2.5.tgz"
  sha256 "9830f25f4c32a1e6c63d64de97694053b07c1905540df553ce72ec85ecd583bd"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "7f239cc177f9ee9c8aab20998e5e8a9fa7a4f4e533a34add60f089a66498bf33"
    sha256                               arm64_ventura:  "01713c308d702c9e2f27fb537df755a16a491b9161ec4a17fc159123b2c7fdc4"
    sha256                               arm64_monterey: "080a5ba05c02c4a312aafc3a4862b95bdec06c3a81e91a23369b0d4c261d3d8d"
    sha256                               sonoma:         "d310ec49076d53412a8fd8914c4354bffb598cf1136c6758f5d67896003e94ee"
    sha256                               ventura:        "d24fbce564ae37bd784474d13d3b673c6e4749f29c9ee85827dc202ae58dfdf4"
    sha256                               monterey:       "e4b35d8d4baf5bd937d091949ef41297cfc7ac65481a0128239d03145709c3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e0e84b3e950e2bd29845d60b15f3865d70010388ef599bbaaa39baed0588db"
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
