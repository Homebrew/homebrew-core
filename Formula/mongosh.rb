require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.8.0.tgz"
  sha256 "fd564c2e467bbd8348fa7ecca407d8a6a82d292b416163b6f76d8b43693295f8"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "48a4d4c55cab83e90257f855cc5309135d49f1c608a0be356ac63ef351407d96"
    sha256                               arm64_monterey: "ceb16ed156d99c74f317fb1e786f939e4b3211c12eb96099725b54306fa1e9a8"
    sha256                               arm64_big_sur:  "5ac9423da33290230f53306ee7d5e0e343ab874b8fce502b3786ae0bcf37540a"
    sha256                               ventura:        "c7562623028fd4688dccd9bcfca1d74d37db2a0b72cbe6be1751783fc653a631"
    sha256                               monterey:       "a1e31b902bb41795baa3f798b72035ef076f3155624ee96c4005eeaa74580039"
    sha256                               big_sur:        "266e183b43b68a339234525deb287dc4333e7ef943eff6422d8af9f96111caf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f3368ab370b898c4982d7f2eddd0daeebbc643fc2393154fcd6939f238edbd"
  end

  depends_on "node@16"

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
