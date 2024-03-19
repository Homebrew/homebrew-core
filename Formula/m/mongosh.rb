require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.2.1.tgz"
  sha256 "345e6900ed5653cf925b62c2219905034a5c07f156a79c29ae7895a445b03698"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "e58595f59631b4d5e37d4d9cd85afbba549688efca201455bcb2a4106a169f6b"
    sha256                               arm64_ventura:  "98a011cbae84bda70ff791f992b56f5bc35c564fa23f879bb6316121b870abfb"
    sha256                               arm64_monterey: "0d65c70d48d9911326ff58ad11baf98faca0fb271b299750b61625e98b888db9"
    sha256                               sonoma:         "6cd593146d9c44d40a73ad04ebe53d555f80a2116310750a038a5c0fd69cf58e"
    sha256                               ventura:        "37aa223193fe9c4824eed817561af25a45d57e27ead0fb1032b827eb17b21352"
    sha256                               monterey:       "c5e616a247dba551a060566196d654a38bbc0e8eef300c80ef170c9c38ee3c51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112fe49341c7629fabda4d91c00602e8c37b739b490713ba19c6fdc3ed9de8cf"
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
