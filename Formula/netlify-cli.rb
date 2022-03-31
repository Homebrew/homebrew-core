require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.15.0.tgz"
  sha256 "1b6dd21d49ceef20bb139ce1a710071f47b8c4642f79dabfcc72debe75a48d64"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "377582b29e602266732b5526b49500d333e74bdbb380a2c3663cee55b6699d91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "377582b29e602266732b5526b49500d333e74bdbb380a2c3663cee55b6699d91"
    sha256 cellar: :any_skip_relocation, monterey:       "234ac70461d105f9efafa56fe862a310bafa301bc2469ab54dd46fd0cb9d9e75"
    sha256 cellar: :any_skip_relocation, big_sur:        "7916e81212cd0dc4c3e3cfc14915620796172a60803f8e750eecd36a498e2c04"
    sha256 cellar: :any_skip_relocation, catalina:       "7916e81212cd0dc4c3e3cfc14915620796172a60803f8e750eecd36a498e2c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32911af1b58d05a8df63d2311d4889fd9053ab5d03cf28322995928223c1cf40"
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
