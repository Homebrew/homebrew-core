require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.38.10.tgz"
  sha256 "ae81496f8348bfda1d11accc78807d328d4592977cb9eef4d6a453a9c201d742"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "076ab4ee8c31f923d1eb82509d6ab6796a6db225436150d042857b1310e2e90a"
    sha256 cellar: :any_skip_relocation, big_sur:       "18cb61f8c64d5532c82613ca9670dacd6893c4ca4666fe84871a636bfafd8623"
    sha256 cellar: :any_skip_relocation, catalina:      "18cb61f8c64d5532c82613ca9670dacd6893c4ca4666fe84871a636bfafd8623"
    sha256 cellar: :any_skip_relocation, mojave:        "18cb61f8c64d5532c82613ca9670dacd6893c4ca4666fe84871a636bfafd8623"
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
