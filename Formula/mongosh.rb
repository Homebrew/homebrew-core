require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.5.tgz"
  sha256 "285d7b1bfba1dc3169fc66854290ffe7a99c8fa6dd1f97ff727a6da923660629"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "b3ccc9884841a620dc251fe7e64fea6f821e3143ccc1f50d65144e32001489b5"
    sha256                               arm64_big_sur:  "2617fba684cd558ffe7131d9cfc7a3fb46b8eb6e27b979c26286123587ab5880"
    sha256                               monterey:       "fa3cc4b075c2bcf713a8f5d4f8e11edeb274b09306a33e39ef1ce4995413c27b"
    sha256                               big_sur:        "df7907d3688daa471076e9f6750718cf3988cafe769fb9b6178536faa4b8efa2"
    sha256                               catalina:       "65dfe79fee20cc149e0302d6bf2b6ec415f10262c14dd7e3ca71a1ab989088e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a76cb36ad1213e5466c70fedd4fc3429e26b73bdac74518759517a778207bdf"
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
