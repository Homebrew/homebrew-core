require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.16.0.tgz"
  sha256 "292aae93ebd47e9b13e34889466c7aa158dfa9b3d8839e2685c47f9447ce5fb7"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45a430d1534ba3c42b8fad4c8f82ccf2a885d17449a21c7abe17b70120e3ede5" => :catalina
    sha256 "d57e7bc50e12f390cd63afdc4e1162386b991339e2c2a8c7bdb32d491e22ddf0" => :mojave
    sha256 "885f071ecf0f6da32163a52cc0bbe14e9e6ad6b2fed8e91cc1014b712c984653" => :high_sierra
  end

  depends_on "node"

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
