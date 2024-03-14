require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.2.0.tgz"
  sha256 "49cfcd7c80f3c9f8630c7cc83405de8f463886cc2cf120b1cfcf2669e9137615"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "042b31fb208a5031cde1223098f931bdcd994b9a59e8283f0ce09b13817263d4"
    sha256                               arm64_ventura:  "c1130678d8c03829a05102de800f49f9529029d27fc3430918b48b433ccd668a"
    sha256                               arm64_monterey: "bdbd291c44aa8947320ac5f94eddc4b942c2c7d762a5292d5a1a71cdc80973cf"
    sha256                               sonoma:         "f671d96d779166d81d8eb08949d94b225a5d0c786ebd38e09a73a6e8286f71cd"
    sha256                               ventura:        "6a50e41a5bcc5455a485ca05e393e7904b8eed76b1ece726c260a197d9e5d36d"
    sha256                               monterey:       "63279451ef586a9ad763e165f82b34f8d69e408b66d12ef82303c54e39576c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebfe0ed95b19353bd589e56d93f238146849f5a275360cd4601a589f107265e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end
