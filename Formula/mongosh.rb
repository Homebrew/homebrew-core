require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.7.1.tgz"
  sha256 "ceb206a224d0130dcba409b9389f4e7982deb54163e332f7aa729853d8cf6120"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "b175c220fbe7dccb53070f612062f420fecc0b2857d27cf0646c34601e4916a1"
    sha256                               arm64_monterey: "b7a8bfdd68194dfc5e0b29deab4dbb49e0e0a78d02326c75d31dc4961852f42d"
    sha256                               arm64_big_sur:  "6b33e1ecbb888480e4da3273d455ff59b789bda956e251e6018394830622558f"
    sha256                               ventura:        "56c3f25e467e4caba230eb7592f01574c51b0d939f751d1cadbae2178b430526"
    sha256                               monterey:       "23e8bf6cc1c37a8da935941d907f58cc1abc22512afd0df2a34a9de65c12e5f5"
    sha256                               big_sur:        "77127b7c8234fbfab87c5186f9b1a8df2d4a70dd8fa38b8046f547a13ace74c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e6111437d3f1c5aeb2bd9e6189ff2d261e5ae1a2d90126a9cb09c9c6e714c8"
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
