require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.6.2.tgz"
  sha256 "393183cbd977cdf52b8d59b868f7438d29f2db2cd0b4cd9646ef7d2cf98dab89"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_ventura:  "2e353a0bb0a18d754d9ae62a4c48b043acca41faf07637d1161968115c6bb7d7"
    sha256                               arm64_monterey: "7622e8e23fc7f234b72ccdc642b393c543e403b72dcbaa1751e0e5f9c96a07fc"
    sha256                               arm64_big_sur:  "d67044aacb363bcb4c1287832855f2608c87cd4011b3335bf9d8b22e1d9cc815"
    sha256                               ventura:        "a1b09f9ca9fe51dabb356d125b2e456d710a100e0822541636bbf81fd4379a16"
    sha256                               monterey:       "1888f9c939e0db68be673af5d0de31bbc3ff2bfa2f4f5ee91ea43171dbca6130"
    sha256                               big_sur:        "76cd73a31f9d6d2343645cdf40e56eb8bc0c1ef19fafa157b6adf8b7bd320b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dac3bf86e760aa4054179f7e4722a9bc7e9b9fd0a3125d8ce6e34ee43dfacffe"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
