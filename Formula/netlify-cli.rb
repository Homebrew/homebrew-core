require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.32.6.tgz"
  sha256 "bcca501f0bc822a10df9db52ab62d5638dc9d1867016467ad7282b95a0895a1d"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d93d15967cd03c645096980ebb7bbc6ef663602bd4dd43260797131e1d3af05"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbfe64187f723dcf7107158f04c55268a5274c9a2cb3f6ca2740e6e626f6fae6"
    sha256 cellar: :any_skip_relocation, catalina:      "dbfe64187f723dcf7107158f04c55268a5274c9a2cb3f6ca2740e6e626f6fae6"
    sha256 cellar: :any_skip_relocation, mojave:        "dbfe64187f723dcf7107158f04c55268a5274c9a2cb3f6ca2740e6e626f6fae6"
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
