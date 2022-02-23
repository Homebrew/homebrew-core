require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.7.0.tgz"
  sha256 "b5c848027e35a5fead4f9ff8638bb4b831e9418d51d0613081b9266735eb1001"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401d8b2ece9365b70ff65553c3156c7eb7defcdd2bdf24ee25cfdf6e4e41a09c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "401d8b2ece9365b70ff65553c3156c7eb7defcdd2bdf24ee25cfdf6e4e41a09c"
    sha256 cellar: :any_skip_relocation, monterey:       "b2cc83818b3a716819f7e8ecce502756a369523860feb304341c90c416feafb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2cc83818b3a716819f7e8ecce502756a369523860feb304341c90c416feafb0"
    sha256 cellar: :any_skip_relocation, catalina:       "b2cc83818b3a716819f7e8ecce502756a369523860feb304341c90c416feafb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6d8005d91d4460fb253956f986adc79c21115aff4436095da9154119080e692"
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
