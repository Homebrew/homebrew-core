require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.5.4.tgz"
  sha256 "b2163fbf1decf33f19a75c888f6a1365be26edcf21ee2e2181a700f70475af28"
  license "Apache-2.0"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 arm64_monterey: "afd60961e76713fcd598cf7241a94006057e527ce0ec254746c3e26103d8e644"
    sha256 arm64_big_sur:  "bab14dc4f97a33337d77aeb1d7a1eedcbd00d1842e4451b35c666658d1daf996"
    sha256 monterey:       "b618e101c7591f80c4138074da22cf956a4d9ab7e37834840ceab6b7f4bc3c4c"
    sha256 big_sur:        "593e89a8fda1465886b55776d840c55bbd490e3a32caedfffe3e093ce099b137"
    sha256 catalina:       "525cf115b605f561e3eb9ff507d6573826dabd1565e6cd94da887b7e92d47d9f"
  end

  depends_on "node@16"

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
