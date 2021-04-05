require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.14.0.tgz"
  sha256 "708153ee852bf6327b1935795173e54dce1855fa20fcfc7b9437c4f570072ce4"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e8d7b977830a6da796427cbf8251f3f6455803c4732d823541159286e475569"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7247726512960fd9998958e7a0f78b58b3aa19b88e0c1065c2fe5d02884f944"
    sha256 cellar: :any_skip_relocation, catalina:      "db8d498f098c116ed68690c757b353d903392477cf3e578b9f14208389a8fc85"
    sha256 cellar: :any_skip_relocation, mojave:        "c1ec6b7cb8b193e43576f494ef6ba9b64e65b1e368da7568c10943d0271a0010"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
