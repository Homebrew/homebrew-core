require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.14.0.tgz"
  sha256 "d35d1ca3b126004081586ad1ac9d2156653fcceb0b21719529c3dbd85c6ba154"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383b2a84e3ce6071775a58ec8389292aff8b5b613a42d129175c8018b4ae8b5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "383b2a84e3ce6071775a58ec8389292aff8b5b613a42d129175c8018b4ae8b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea0694bb3f6bf408560b056cbd6379791172496996c07918acd0a4ade40034a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ea0694bb3f6bf408560b056cbd6379791172496996c07918acd0a4ade40034a"
    sha256 cellar: :any_skip_relocation, catalina:       "1ea0694bb3f6bf408560b056cbd6379791172496996c07918acd0a4ade40034a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd83d6e338f5684eaed2cf2b4b200582c669a50482bb32ebe8a86f3428893d11"
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
