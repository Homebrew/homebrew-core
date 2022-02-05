require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.16.0.tgz"
  sha256 "29c26183879d7bef057f70cf13627eb9a5fa6cf474add139ae3aa9392bfc8575"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db74ed0846baf7b57a7647162ed8f023a266f51714192e727cfcacbc1e3feee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db74ed0846baf7b57a7647162ed8f023a266f51714192e727cfcacbc1e3feee4"
    sha256 cellar: :any_skip_relocation, monterey:       "95813a6d4a213fb797562844badb18cbad62b1d40520d5e61651d1df044d2fe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "95813a6d4a213fb797562844badb18cbad62b1d40520d5e61651d1df044d2fe2"
    sha256 cellar: :any_skip_relocation, catalina:       "95813a6d4a213fb797562844badb18cbad62b1d40520d5e61651d1df044d2fe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48dd4f26636986426d0acc963442a39f66153d0bc3a0b203299d1e8222aff641"
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
