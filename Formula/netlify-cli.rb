require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.8.10.tgz"
  sha256 "bea250205a00c79b939ef50cdbcd5c2edf8b9cd23c0429f3b97ade5ab529fee6"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bb5c5cbfc0e1ba7dbe8ccde784e849e3ac45c6fd0bfd1400be292db17eddab5"
    sha256 cellar: :any_skip_relocation, big_sur:       "0982581b5d28735b75597b8d0644d682f7fa0045acd5628cba25e6e7f61a20c4"
    sha256 cellar: :any_skip_relocation, catalina:      "0982581b5d28735b75597b8d0644d682f7fa0045acd5628cba25e6e7f61a20c4"
    sha256 cellar: :any_skip_relocation, mojave:        "0982581b5d28735b75597b8d0644d682f7fa0045acd5628cba25e6e7f61a20c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ceccfcd9cbe86fcc75be1b1565da0548da3696a3d82fbfbfe5bdb9f611c0996"
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
