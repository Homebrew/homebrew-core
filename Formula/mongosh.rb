require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.1.8.tgz"
  sha256 "eca227ea81100db325623bba44b5b9ab6e9f567aad1c2050822d5135fe585efa"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_monterey: "77e176ceeaaaa7f53b2d340abf5e7f57fb7a0fb1d17d5630d910db8ca98879af"
    sha256                               arm64_big_sur:  "0989ba2242265c7d445fc130d028903b05f8d3da2ee46ce7062ad79d97fa73da"
    sha256                               monterey:       "e8ba1abff3b4c16734ff5e126aba00702964d956d02ff1e62d0be4477527bfd5"
    sha256                               big_sur:        "7279e95556429663fcd01028d2e3e1f177e26490a65791494a0de86acaff5970"
    sha256                               catalina:       "be7652c7bb6b0b220fe4a81ffbc262c3dcee8e605b878c9e70d377a8b1d84294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "247fbcf73f3be16add3fff0f5c4a06efd32c3224f78f7d253743c545ce51a931"
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
