require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.8.0.tgz"
  sha256 "fd564c2e467bbd8348fa7ecca407d8a6a82d292b416163b6f76d8b43693295f8"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "88f0da8ad04c9431825e53aa88045d3e2b0cbf3d23cf6f1856cd97156cb3f7f7"
    sha256                               arm64_monterey: "79c5c6bee9c5ef7782cca3893b3ca0287ae6f2de22f0b5f3520355781499ab95"
    sha256                               arm64_big_sur:  "fa14acbad9c911be9aeef81f491e879a20b88eb24468fd99bf9f83d126e16a8e"
    sha256                               ventura:        "3ff792c1da8276f7e9d896939d87df8479ab0cd6665ae6744c85c08631b4d11d"
    sha256                               monterey:       "6f2f353758a0389b58ad07ead5202937fc8abe1933cbf880f08ca6212ae25650"
    sha256                               big_sur:        "e8715887c314d9854fbab640b98b345ad4ed76547e0cc18b077f6ff9e9962421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "babbf1c006be0af4da656eb947f6fde2465e913e808ffd74c776058d9a4fb33a"
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
