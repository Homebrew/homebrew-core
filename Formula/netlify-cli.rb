require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.8.10.tgz"
  sha256 "bea250205a00c79b939ef50cdbcd5c2edf8b9cd23c0429f3b97ade5ab529fee6"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1705353014474fab897cb1cf5c38bcb4998d079247cd9c94831a1a087290f8bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b0a41e633d5b973fbfc026039f36257de772376af0f02c1f21a18474fb65649"
    sha256 cellar: :any_skip_relocation, catalina:      "9b0a41e633d5b973fbfc026039f36257de772376af0f02c1f21a18474fb65649"
    sha256 cellar: :any_skip_relocation, mojave:        "9b0a41e633d5b973fbfc026039f36257de772376af0f02c1f21a18474fb65649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f3f32aff6edf0df64cfbb77e934d985b39ad7aa20d7ac0855f97b0f425d633"
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
