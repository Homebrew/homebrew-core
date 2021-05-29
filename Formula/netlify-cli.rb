require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.31.16.tgz"
  sha256 "d5a6f13dcd347a9169c99791f5da460d6b2079fd72d5cd1d94fca3726175acab"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9cb70804f5e0024af0bf283b5d828522f6ac30afa9aa25f0b6ed24f132f73434"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd8a6d4f0eca3041e40378cf03906476493bd746a34dbc47a3e02114dc616329"
    sha256 cellar: :any_skip_relocation, catalina:      "cd8a6d4f0eca3041e40378cf03906476493bd746a34dbc47a3e02114dc616329"
    sha256 cellar: :any_skip_relocation, mojave:        "a06535346d2816d7cef26a75772441f67ef36b8afefec339a077f7d6b06c8144"
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
