require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.0.5.tgz"
  sha256 "d1c2e9852fe5dbfdb9dd2b485bc9bf823037700132e937052ca0dc5b2ee71808"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "d1f25ff81fe548a09a6a91408aaa770766eeff1a06f5a199d0a557c55c524d52"
    sha256                               big_sur:       "36c31f20e685f007af38124c0de73e59dccb384e8775925c94cbe2d1bd7de620"
    sha256                               catalina:      "fd8f646f7f24c64dff4560a78ab0cac260cf22df22db0dac9d1188217efd995b"
    sha256                               mojave:        "db5da054098bba8f9c06fbfc0c5d48ec022629561f71289c46b8872e15115630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0551e87d919ea79db27006c2f2a4c263a7246e9e99d14a4cd8462e59582a516"
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
