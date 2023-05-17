require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.9.0.tgz"
  sha256 "b6c65dc5c55cdf49a35fc07b3179bdf2d2cd827b00b9422695d9c4b280125b40"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "a097528d6ab315770ea484b8f4d7e15773187aee2e40bd9fc457ceb425a40675"
    sha256                               arm64_monterey: "d2a699aed50cbc0ccdc508debfa519235c8baf145c003e8a0cfac3076444d396"
    sha256                               arm64_big_sur:  "a31f23901965a7264f57d352c42faf7d44e8adf7b5da92ab1fc6951af5ec958b"
    sha256                               ventura:        "982d011272c48b5133af38ccf4982b660eeddf9b7b210362365b887ab2affc67"
    sha256                               monterey:       "a59c7ed37a329f9475a2793c95ca74821cb66afed50bd82fedeb6a294de75b0d"
    sha256                               big_sur:        "bc2255f6edae122b99bb35b1ef5a7b87bb22bd0a6a2c95acb7e647da8787cfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11c65247ab9ab225a4169471fdf5a231b4fd9854bac9e6817aecda9073dcfeeb"
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
