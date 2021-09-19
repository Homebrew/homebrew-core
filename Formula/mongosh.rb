require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.0.6.tgz"
  sha256 "f4feb1d03cb54649e9222f2d4e9577b03f4eabf88fd3a40301f9e60adc5614f0"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_big_sur: "789afc3b1f403c4826a49589fc4175ce0b9c74a5779ba8f7143420c7abb1baf4"
    sha256                               big_sur:       "dc6b72a59e8ddc4451e23ff0382bdf4a0371cf0487fbbb8cc738e94d75f4a62f"
    sha256                               catalina:      "feb7ef3cc7650d7d19d437467b8dbb6fadfeeeb62c9914b0e66d5be1ebf16978"
    sha256                               mojave:        "f419127fbb95e6dd0c025fa64798dac4e7b7530c6f6008fb41c57c2cc23e5695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "633b340294d9455de1eee8a30006fd44ae5d4d9bdb22827e5c333352bf6dcfc3"
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
