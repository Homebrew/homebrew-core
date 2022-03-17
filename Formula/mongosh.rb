require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.3.0.tgz"
  sha256 "acc681699a44971db74a8783db4a9e811171c0d2212077cc53a673d69510833b"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "2ed4afe44c5517aaa41197816924bb0e443bc30ffabc1e6c816a8fcfb9938b78"
    sha256                               arm64_big_sur:  "ec305df73b07055bde8d14ab19fd0d38d3a3166cb8dbd71ac4a3bace8633398d"
    sha256                               monterey:       "8730ec777c36157d71eda66a779a014a7f238065aec69d934c68bf67bf87b926"
    sha256                               big_sur:        "bbdf44663e4cdb5c8631bf2f2d8c512d27e10d4da1fdf36380543c1520524d69"
    sha256                               catalina:       "f730ad550881bc931f2801cddb1d34a4b51fa41abf42dceddb37b8181b12e590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43db975d00b8cc0a2563f865f9bca7ca9c60b9b67ff4e7a4d33eea845dbcf154"
  end

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
