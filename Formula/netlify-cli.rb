require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.1.15.tgz"
  sha256 "e2c251946647906c8285834d00be25e2ff14838e4dcd3cb2c52befa0c89e587b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af28f2ddee52b7f3ee2ed18b1fddfb868bcfa1670af3516e7b046e4bfdfc04a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ece7af8838251c2df34dcd94910331b8bef2a6f35835fdc05781b47229a7bfe"
    sha256 cellar: :any_skip_relocation, catalina:      "6ece7af8838251c2df34dcd94910331b8bef2a6f35835fdc05781b47229a7bfe"
    sha256 cellar: :any_skip_relocation, mojave:        "6ece7af8838251c2df34dcd94910331b8bef2a6f35835fdc05781b47229a7bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb60f6baea5adfcdf2c8c0c27eef9eaa16ca4ee419bc98430414ad8bea09c3ed"
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
